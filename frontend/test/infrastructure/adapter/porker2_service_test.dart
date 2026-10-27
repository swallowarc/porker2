import 'dart:async';

import 'package:connectrpc/connect.dart';
import 'package:connectrpc/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:porker2fe/core/error/error.dart';
import 'package:porker2fe/core/logger/logger.dart';
import 'package:porker2fe/domain/room.dart';
import 'package:porker2fe/domain/user.dart';
import 'package:porker2fe/infrastructure/adapter/porker2_service.dart';
import 'package:porker2fe/infrastructure/generated/pb/porker/v2/domain.pb.dart';
import 'package:porker2fe/infrastructure/generated/pb/porker/v2/service.connect.client.dart';
import 'package:porker2fe/infrastructure/generated/pb/porker/v2/service.connect.spec.dart'
    as spec;
import 'package:porker2fe/infrastructure/generated/pb/porker/v2/service.pb.dart';

Porker2ServiceImpl _service(FakeTransportBuilder builder) =>
    Porker2ServiceImpl(Porker2ServiceClient(builder.build()));

void main() {
  setUpAll(() {
    logger.hashCode;
    Logger.level = Level.off;
  });

  group('error translation', () {
    test('unauthenticated becomes UnauthenticatedError on every rpc', () async {
      final svc = _service(FakeTransportBuilder()
          .unary(spec.Porker2Service.verifyUser, (_, _) =>
              throw ConnectException(Code.unauthenticated, 'expired'))
          .unary(spec.Porker2Service.castVote, (_, _) =>
              throw ConnectException(Code.unauthenticated, 'expired')));

      await expectLater(svc.verifyUser(), throwsA(isA<UnauthenticatedError>()));
      await expectLater(svc.castVote('11111', Point.POINT_1),
          throwsA(isA<UnauthenticatedError>()));
    });

    test('login maps alreadyExists to alreadyUsedNameError', () async {
      final svc = _service(FakeTransportBuilder().unary(
          spec.Porker2Service.login,
          (_, _) => throw ConnectException(Code.alreadyExists, 'dup')));

      await expectLater(svc.login('bob'), throwsA(same(alreadyUsedNameError)));
    });

    test('checkRoom maps notFound and failedPrecondition to room errors',
        () async {
      var code = Code.notFound;
      final svc = _service(FakeTransportBuilder().unary(
          spec.Porker2Service.checkRoom,
          (_, _) => throw ConnectException(code, 'room')));

      await expectLater(svc.checkRoom('11111'), throwsA(same(roomNotFoundError)));
      code = Code.failedPrecondition;
      await expectLater(svc.checkRoom('11111'), throwsA(same(roomFullError)));
    });

    test('other codes become UnexpectedError carrying the cause', () async {
      final svc = _service(FakeTransportBuilder().unary(
          spec.Porker2Service.createRoom,
          (_, _) => throw ConnectException(Code.internal, 'boom')));

      await expectLater(
        svc.createRoom(),
        throwsA(isA<UnexpectedError>()
            .having((e) => e.cause, 'cause', isA<ConnectException>())),
      );
    });

    test('successful rpcs return their values', () async {
      final svc = _service(FakeTransportBuilder()
          .unary(spec.Porker2Service.login,
              (LoginRequest req, _) => LoginResponse(userId: 'u-${req.userName}'))
          .unary(spec.Porker2Service.verifyUser,
              (_, _) => VerifyUserResponse(userId: 'u1', userName: 'bob'))
          .unary(spec.Porker2Service.createRoom,
              (_, _) => CreateRoomResponse(roomId: '12345')));

      expect(await svc.login('bob'), (userID: 'u-bob'));
      expect(await svc.verifyUser(),
          const UserEntity(userID: 'u1', userName: 'bob'));
      expect(await svc.createRoom(), '12345');
    });
  });

  group('joinRoom', () {
    test('yields conditions until the server closes the stream', () async {
      final svc = _service(FakeTransportBuilder().server(
          spec.Porker2Service.joinRoom,
          (JoinRoomRequest req, _) => Stream.fromIterable([
                JoinRoomResponse(condition: RoomCondition(roomId: req.roomId)),
                JoinRoomResponse(condition: RoomCondition(roomId: req.roomId)),
              ])));

      final conditions = await svc.joinRoom('11111').toList();
      expect(conditions.map((c) => c.roomId), ['11111', '11111']);
    });

    test('translates notFound into roomNotFoundError', () async {
      final svc = _service(FakeTransportBuilder().server(
          spec.Porker2Service.joinRoom,
          (_, _) => Stream.error(ConnectException(Code.notFound, 'gone'))));

      await expectLater(
          svc.joinRoom('11111').toList(), throwsA(same(roomNotFoundError)));
    });

    test('translates unauthenticated into UnauthenticatedError', () async {
      final svc = _service(FakeTransportBuilder().server(
          spec.Porker2Service.joinRoom,
          (_, _) =>
              Stream.error(ConnectException(Code.unauthenticated, 'expired'))));

      await expectLater(svc.joinRoom('11111').toList(),
          throwsA(isA<UnauthenticatedError>()));
    });
  });

  group('joinRoom retry', () {
    /// JoinRoom を呼ばれた回数と、進行中のリクエストが中断されたかを記録する
    late int calls;
    late List<bool> aborted;

    Porker2ServiceImpl service(
      Stream<JoinRoomResponse> Function(int call, FakeHandlerContext ctx)
          respond, {
      Duration retryInterval = Duration.zero,
    }) {
      calls = 0;
      aborted = [];
      final transport = FakeTransportBuilder().server(
        spec.Porker2Service.joinRoom,
        (JoinRoomRequest req, FakeHandlerContext ctx) {
          final index = calls++;
          aborted.add(false);
          ctx.signal.future.then((_) => aborted[index] = true);
          return respond(index, ctx);
        },
      ).build();
      return Porker2ServiceImpl(Porker2ServiceClient(transport),
          retryInterval: retryInterval);
    }

    test('reconnects after a retryable error', () async {
      final svc = service((call, _) => call == 0
          ? Stream.error(ConnectException(Code.unavailable, 'flaky'))
          : Stream.value(
              JoinRoomResponse(condition: RoomCondition(roomId: '11111'))));

      final conditions = await svc.joinRoom('11111').toList();
      expect(conditions.map((c) => c.roomId), ['11111']);
      expect(calls, 2);
    });

    test('does not reconnect when cancelled during the retry wait', () async {
      final svc = service(
        (_, _) => Stream.error(ConnectException(Code.unavailable, 'flaky')),
        retryInterval: const Duration(milliseconds: 20),
      );

      final sub = svc.joinRoom('11111').listen((_) {});
      await Future<void>.delayed(const Duration(milliseconds: 5));
      expect(calls, 1);
      await sub.cancel();
      await Future<void>.delayed(const Duration(milliseconds: 60));
      expect(calls, 1, reason: 'cancel 後に JoinRoom を呼び直さない');
    });

    test('cancel aborts the in-flight request', () async {
      // 中断されるまで何も流さないストリーム (実際の transport は中断でエラーになる)
      final svc = service((_, ctx) {
        final controller = StreamController<JoinRoomResponse>();
        ctx.signal.future.then(controller.addError);
        return controller.stream;
      });

      final sub = svc.joinRoom('11111').listen((_) {});
      await Future<void>.delayed(Duration.zero);
      expect(aborted, [false]);
      await sub.cancel();
      await Future<void>.delayed(Duration.zero);
      expect(aborted, [true]);
    });
  });
}

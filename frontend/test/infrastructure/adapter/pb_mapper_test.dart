import 'package:flutter_test/flutter_test.dart';
import 'package:porker2fe/core/error/error.dart';
import 'package:porker2fe/domain/point.dart';
import 'package:porker2fe/domain/room.dart';
import 'package:porker2fe/infrastructure/adapter/pb_mapper.dart';
import 'package:porker2fe/infrastructure/generated/pb/porker/v2/domain.pb.dart'
    as pb;

void main() {
  group('Point', () {
    test('round-trips every domain value', () {
      for (final p in Point.values) {
        expect(pointFromPb(pointToPb(p)), p, reason: p.name);
      }
    });

    test('maps every proto value', () {
      for (final p in pb.Point.values) {
        expect(pointToPb(pointFromPb(p)), p, reason: p.name);
      }
    });
  });

  group('DisplayMode', () {
    test('round-trips', () {
      for (final m in DisplayMode.values) {
        expect(displayModeFromPb(displayModeToPb(m)), m, reason: m.name);
      }
    });

    test('rejects unspecified', () {
      expect(() => displayModeFromPb(pb.DisplayMode.DISPLAY_MODE_UNSPECIFIED),
          throwsA(isA<UnexpectedError>()));
    });
  });

  group('VoteState / UserRole', () {
    test('map known values and reject unspecified', () {
      expect(voteStateFromPb(pb.VoteState.VOTE_STATE_HIDE), VoteState.hide);
      expect(voteStateFromPb(pb.VoteState.VOTE_STATE_OPEN), VoteState.open);
      expect(() => voteStateFromPb(pb.VoteState.VOTE_STATE_UNSPECIFIED),
          throwsA(isA<UnexpectedError>()));

      expect(userRoleFromPb(pb.UserRole.USER_ROLE_VOTER), UserRole.voter);
      expect(userRoleFromPb(pb.UserRole.USER_ROLE_OBSERVER), UserRole.observer);
      expect(() => userRoleFromPb(pb.UserRole.USER_ROLE_UNSPECIFIED),
          throwsA(isA<UnexpectedError>()));
    });
  });

  test('roomFromPb converts the whole condition', () {
    final room = roomFromPb(pb.RoomCondition(
      roomId: '12345',
      adminUserId: 'admin',
      voteState: pb.VoteState.VOTE_STATE_OPEN,
      autoOpen: false,
      displayMode: pb.DisplayMode.DISPLAY_MODE_TSHIRT,
      ballots: [
        pb.Ballot(
            userId: 'a',
            userName: 'alice',
            point: pb.Point.POINT_5,
            role: pb.UserRole.USER_ROLE_VOTER),
        pb.Ballot(
            userId: 'o',
            userName: 'olive',
            point: pb.Point.POINT_UNSPECIFIED,
            role: pb.UserRole.USER_ROLE_OBSERVER),
      ],
    ));

    expect(
      room,
      const Room(
        roomID: '12345',
        adminUserID: 'admin',
        voteState: VoteState.open,
        autoOpen: false,
        displayMode: DisplayMode.tshirt,
        ballots: [
          Ballot(
              userID: 'a',
              userName: 'alice',
              point: Point.p5,
              role: UserRole.voter),
          Ballot(
              userID: 'o',
              userName: 'olive',
              point: Point.unspecified,
              role: UserRole.observer),
        ],
      ),
    );
  });
}

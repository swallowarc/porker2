import 'package:grpc/grpc_web.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/core/env/env.dart';
import 'package:porker2fe/data/datasource/pb/porker/v2/service.pbgrpc.dart';
import 'package:porker2fe/data/repository/local_storage_repository.dart';
import 'package:porker2fe/data/repository/porker2_service_repository.dart';
import 'package:porker2fe/domain/port/repository.dart';
import 'package:porker2fe/domain/usecase/direct_room_join.dart';
import 'package:porker2fe/domain/usecase/poker.dart';
import 'package:porker2fe/domain/usecase/user.dart';

/// core layer -----------------------------------------------------------------

final Provider<Env> envProvider = Provider<Env>((ref) => Env());

/// data layer -----------------------------------------------------------------

Provider<Porker2ServiceClient> porker2ServiceApiProvider =
    Provider<Porker2ServiceClient>((ref) {
  final env = ref.read(envProvider);
  final channel = GrpcWebClientChannel.xhr(Uri.parse(env.backendURI));
  ref.onDispose(() => channel.shutdown());

  return Porker2ServiceClient(channel,
      options: WebCallOptions(withCredentials: true));
});

/// interface layer ------------------------------------------------------------

/// repository

Provider<LocalStorageRepository> localStorageRepositoryProvider =
    Provider<LocalStorageRepository>((ref) => LocalStorageRepositoryImpl());

Provider<Porker2ServiceRepository> porker2ServiceRepositoryProvider =
    Provider<Porker2ServiceRepository>((ref) =>
        Porker2ServiceRepositoryImpl(ref.read(porker2ServiceApiProvider)));

/// domain layer ---------------------------------------------------------------

/// usecase

StateNotifierProvider<User, UserState> userProvider =
    StateNotifierProvider<User, UserState>((ref) => User(
          ref.read(porker2ServiceRepositoryProvider),
          ref.read(localStorageRepositoryProvider),
        ));

StateNotifierProvider<Poker, PokerState> pokerProvider =
    StateNotifierProvider<Poker, PokerState>((ref) => Poker(
          ref.read(porker2ServiceRepositoryProvider),
        ));

StateNotifierProvider<DirectRoomJoin, DirectRoomJoinState>
    directRoomJoinProvider =
    StateNotifierProvider<DirectRoomJoin, DirectRoomJoinState>(
        (ref) => DirectRoomJoin());

import 'package:grpc/grpc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/core/env/env.dart';
import 'package:porker2fe/data/datasource/pb/porker/v2/service.pbgrpc.dart';
import 'package:porker2fe/data/repository/local_storage_repository.dart';
import 'package:porker2fe/data/repository/porker2_service_repository.dart';
import 'package:porker2fe/domain/port/repository.dart';
import 'package:porker2fe/domain/usecase/user.dart';

final Provider<Env> envProvider = Provider<Env>((ref) => Env());

/// data layer

final grpcChannelProvider = Provider.autoDispose<ClientChannel>((ref) {
  final env = ref.read(envProvider);
  final channel = ClientChannel(
    env.backendURI,
    port: env.backendPort,
    options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
  );

  ref.onDispose(() {
    channel.shutdown();
  });

  return channel;
});

Provider<Porker2ServiceClient> porker2ServiceApiProvider =
    Provider<Porker2ServiceClient>(
        (ref) => Porker2ServiceClient(ref.read(grpcChannelProvider)));

/// port

Provider<LocalStorageRepository> localStorageRepositoryProvider =
    Provider<LocalStorageRepository>((ref) => LocalStorageRepositoryImpl());

Provider<Porker2ServiceRepository> porker2ServiceRepositoryProvider =
    Provider<Porker2ServiceRepository>((ref) =>
        Porker2ServiceRepositoryImpl(ref.read(porker2ServiceApiProvider)));

/// domain layer

Provider<User> userProvider = Provider<User>((ref) => User(
      ref.read(porker2ServiceRepositoryProvider),
      ref.read(localStorageRepositoryProvider),
    ));

import 'package:grpc/grpc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/core/env/env.dart';
import 'package:porker2fe/data/datasource/local_storage/local_storage.dart';
import 'package:porker2fe/data/datasource/pb/porker/v2/service.pbgrpc.dart';
import 'package:porker2fe/domain/usecase/user.dart';

final Provider<Env> envProvider = Provider<Env>((ref) => Env());

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

Provider<LocalStorage> localStorageProvider =
    Provider<LocalStorage>((ref) => LocalStorage());

Provider<User> userProvider = Provider<User>((ref) {
  final apiCli = ref.read(porker2ServiceApiProvider);
  final localStorage = ref.read(localStorageProvider);
  return User(apiCli, localStorage);
});

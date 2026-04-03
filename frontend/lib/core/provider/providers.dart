import 'package:grpc/grpc_web.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/core/env/env.dart';
import 'package:porker2fe/infrastructure/generated/pb/porker/v2/service.pbgrpc.dart';
import 'package:porker2fe/infrastructure/adapter/local_storage.dart';
import 'package:porker2fe/infrastructure/adapter/porker2_service.dart';
import 'package:porker2fe/application/port/port.dart';

/// core layer -----------------------------------------------------------------

final envProvider = Provider<Env>((ref) => Env());

/// infrastructure layer -------------------------------------------------------

final porker2ServiceApiProvider = Provider<Porker2ServiceClient>((ref) {
  final env = ref.read(envProvider);
  final channel = GrpcWebClientChannel.xhr(Uri.parse(env.backendURI));
  ref.onDispose(() => channel.shutdown());

  return Porker2ServiceClient(channel,
      options: WebCallOptions(withCredentials: true));
});

/// adapter

final localStorageProvider =
    Provider<LocalStorage>((ref) => LocalStorageImpl());

final porker2ServiceProvider =
    Provider<Porker2Service>((ref) =>
        Porker2ServiceImpl(ref.read(porker2ServiceApiProvider)));

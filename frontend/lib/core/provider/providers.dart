import 'package:grpc/grpc_web.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/core/env/env.dart';
import 'package:porker2fe/infrastructure/datasource/pb/porker/v2/service.pbgrpc.dart';
import 'package:porker2fe/infrastructure/gateway/local_storage.dart';
import 'package:porker2fe/infrastructure/gateway/porker2_service.dart';
import 'package:porker2fe/domain/port/port.dart';

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

/// gateway

final localStorageProvider =
    Provider<LocalStorage>((ref) => LocalStorageImpl());

final porker2ServiceProvider =
    Provider<Porker2Service>((ref) =>
        Porker2ServiceImpl(ref.read(porker2ServiceApiProvider)));

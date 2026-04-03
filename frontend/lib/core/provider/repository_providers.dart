import 'package:grpc/grpc_web.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/core/env/env.dart';
import 'package:porker2fe/data/datasource/pb/porker/v2/service.pbgrpc.dart';
import 'package:porker2fe/data/repository/local_storage_repository.dart';
import 'package:porker2fe/data/repository/porker2_service_repository.dart';
import 'package:porker2fe/domain/port/repository.dart';

/// core layer -----------------------------------------------------------------

final envProvider = Provider<Env>((ref) => Env());

/// data layer -----------------------------------------------------------------

final porker2ServiceApiProvider = Provider<Porker2ServiceClient>((ref) {
  final env = ref.read(envProvider);
  final channel = GrpcWebClientChannel.xhr(Uri.parse(env.backendURI));
  ref.onDispose(() => channel.shutdown());

  return Porker2ServiceClient(channel,
      options: WebCallOptions(withCredentials: true));
});

/// interface layer ------------------------------------------------------------

/// repository

final localStorageRepositoryProvider =
    Provider<LocalStorageRepository>((ref) => LocalStorageRepositoryImpl());

final porker2ServiceRepositoryProvider =
    Provider<Porker2ServiceRepository>((ref) =>
        Porker2ServiceRepositoryImpl(ref.read(porker2ServiceApiProvider)));

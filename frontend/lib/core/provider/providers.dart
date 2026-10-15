import 'package:connectrpc/connect.dart';
import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/connect.dart' as protocol;
import 'package:connectrpc/web.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/core/env/env.dart';
import 'package:porker2fe/infrastructure/generated/pb/porker/v2/service.connect.client.dart';
import 'package:porker2fe/infrastructure/adapter/local_storage.dart';
import 'package:porker2fe/infrastructure/adapter/porker2_service.dart';
import 'package:porker2fe/application/port/port.dart';

/// core layer -----------------------------------------------------------------

final envProvider = Provider<Env>((ref) => Env());

/// infrastructure layer -------------------------------------------------------

final porker2ServiceApiProvider = Provider<Porker2ServiceClient>((ref) {
  final env = ref.read(envProvider);
  final Transport transport = protocol.Transport(
    baseUrl: env.backendURI,
    codec: const ProtoCodec(),
    // tokenはcookieで送受信するため、クロスオリジンでもcookieを含める
    httpClient: createHttpClient(credentials: 'include'),
  );

  return Porker2ServiceClient(transport);
});

/// adapter

final localStorageProvider =
    Provider<LocalStorage>((ref) => LocalStorageImpl());

final porker2ServiceProvider =
    Provider<Porker2Service>((ref) =>
        Porker2ServiceImpl(ref.read(porker2ServiceApiProvider)));

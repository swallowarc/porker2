import 'package:connectrpc/connect.dart';
import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/connect.dart' as protocol;
import 'package:connectrpc/web.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/application/provider.dart';
import 'package:porker2fe/core/env/env.dart';
import 'package:porker2fe/infrastructure/adapter/local_storage.dart';
import 'package:porker2fe/infrastructure/adapter/porker2_service.dart';
import 'package:porker2fe/infrastructure/generated/pb/porker/v2/service.connect.client.dart';

/// application 層のポートに infrastructure 層の実装を差し込む。
/// アプリの起動時に [ProviderScope.overrides] へ渡す (composition root)。
/// (Override 型は hooks_riverpod から公開されていないため、型は推論に任せる)
final infrastructureOverrides = [
  porker2ServiceProvider.overrideWith(
    (ref) => Porker2ServiceImpl(_newClient(ref.read(envProvider))),
  ),
  localStorageProvider.overrideWith((ref) => LocalStorageImpl()),
];

Porker2ServiceClient _newClient(Env env) {
  final Transport transport = protocol.Transport(
    baseUrl: env.backendURI,
    codec: const ProtoCodec(),
    // tokenはcookieで送受信するため、クロスオリジンでもcookieを含める
    httpClient: createHttpClient(credentials: 'include'),
  );
  return Porker2ServiceClient(transport);
}

import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/core/logger/logger.dart';
import 'package:porker2fe/presentation/page/login_page.dart';
import 'package:porker2fe/presentation/page/poker_page.dart';
import 'package:porker2fe/presentation/page/room_select_page.dart';
import 'package:porker2fe/application/provider.dart';
import 'package:porker2fe/presentation/router/paths.dart';
import 'package:porker2fe/presentation/router/redirect.dart';

part 'router.g.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final env = ref.read(envProvider);

  // ログイン状態が変わったら redirect を再評価する。ログアウト中に部屋の購読が終わって
  // 部屋選択へ遷移した後でも、状態が消えた時点でログイン画面へ送り返せる
  final refresh = _RefreshNotifier();
  ref.onDispose(refresh.dispose);
  ref.listen(userProvider.select((s) => s.isLoggedIn), (_, _) => refresh.refresh());

  return GoRouter(
    debugLogDiagnostics: !env.isProduction,
    initialLocation: LoginRoute().location,
    routes: $appRoutes,
    refreshListenable: refresh,
    redirect: (context, state) {
      final isLoggedIn = ref.read(userProvider).isLoggedIn;
      logger.d('isLoggedIn: $isLoggedIn, path: ${state.fullPath}');
      return resolveRedirect(
        isLoggedIn: isLoggedIn,
        path: state.fullPath,
        roomID: state.uri.queryParameters[roomIDParam] ?? '',
      );
    },
  );
});

class _RefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}

@TypedGoRoute<LoginRoute>(
  path: loginPath,
)
class LoginRoute extends GoRouteData with $LoginRoute {
  LoginRoute({this.roomId = ""});

  /// 未ログインで部屋 URL を開いたときに redirect が引き継ぐ room-id。ログイン後にその部屋へ入る
  final String roomId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LoginPage(roomId: roomId);
  }
}

@TypedGoRoute<RoomSelectRoute>(
  path: roomSelectPath,
)
class RoomSelectRoute extends GoRouteData with $RoomSelectRoute {
  RoomSelectRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const RoomSelectPage();
  }
}

@TypedGoRoute<PokerRoute>(
  path: pokerPath,
)
class PokerRoute extends GoRouteData with $PokerRoute {
  PokerRoute({this.roomId = ""});

  final String roomId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PokerPage(roomId);
  }
}

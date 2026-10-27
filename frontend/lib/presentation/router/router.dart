import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/core/logger/logger.dart';
import 'package:porker2fe/domain/room.dart';
import 'package:porker2fe/presentation/page/login_page.dart';
import 'package:porker2fe/presentation/page/poker_page.dart';
import 'package:porker2fe/presentation/page/room_select_page.dart';
import 'package:porker2fe/presentation/provider/provider.dart';

part 'router.g.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final env = ref.read(envProvider);
  return GoRouter(
    debugLogDiagnostics: !env.isProduction,
    initialLocation: LoginRoute().location,
    routes: $appRoutes,
    redirect: (context, state) {
      final isLoggedIn = ref.read(userProvider.notifier).alreadyLogin;
      final path = state.fullPath;
      final isLogin = path == LoginRoute().location;
      final isPoker = path == PokerRoute().location;
      final roomID = state.uri.queryParameters[PokerRoute.roomIDParam] ?? '';

      logger.d('isLoggedIn: $isLoggedIn, path: $path');

      if (isLoggedIn) {
        // ログイン済みで room-id が不正な /poker は入室できないので部屋選択へ戻す
        if (isPoker && !roomIDFormatRegExp.hasMatch(roomID)) {
          return RoomSelectRoute().location;
        }
        return null;
      }

      if (isLogin) {
        return null;
      }

      // 未ログインで部屋 URL を直接開いた場合は、ログイン完了後にその部屋へ入るため
      // room-id を預けてからログイン画面へ送る
      if (isPoker && roomIDFormatRegExp.hasMatch(roomID)) {
        ref.read(directRoomJoinProvider.notifier).setPresetRoomID(roomID);
      }
      return LoginRoute().location;
    },
  );
});

@TypedGoRoute<LoginRoute>(
  path: '/',
)
class LoginRoute extends GoRouteData with $LoginRoute {
  LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginPage();
  }
}

@TypedGoRoute<RoomSelectRoute>(
  path: '/room',
)
class RoomSelectRoute extends GoRouteData with $RoomSelectRoute {
  RoomSelectRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const RoomSelectPage();
  }
}

@TypedGoRoute<PokerRoute>(
  path: '/poker',
)
class PokerRoute extends GoRouteData with $PokerRoute {
  PokerRoute({this.roomId = ""});

  /// クエリパラメータ名。go_router_builder がフィールド名 `roomId` から生成する。
  static const roomIDParam = 'room-id';

  final String roomId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PokerPage(roomId);
  }
}

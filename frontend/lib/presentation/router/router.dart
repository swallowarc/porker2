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
  return GoRouter(
    debugLogDiagnostics: !env.isProduction,
    initialLocation: LoginRoute().location,
    routes: $appRoutes,
    redirect: (context, state) {
      final isLoggedIn = ref.read(userProvider.notifier).alreadyLogin;
      logger.d('isLoggedIn: $isLoggedIn, path: ${state.fullPath}');
      return resolveRedirect(
        isLoggedIn: isLoggedIn,
        path: state.fullPath,
        roomID: state.uri.queryParameters[roomIDParam] ?? '',
        parkRoomID: ref.read(directRoomJoinProvider.notifier).setPresetRoomID,
      );
    },
  );
});

@TypedGoRoute<LoginRoute>(
  path: loginPath,
)
class LoginRoute extends GoRouteData with $LoginRoute {
  LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginPage();
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

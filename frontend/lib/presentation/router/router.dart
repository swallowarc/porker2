import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/core/logger/logger.dart';
import 'package:porker2fe/presentation/page/login_page.dart';
import 'package:porker2fe/presentation/page/poker_page.dart';
import 'package:porker2fe/presentation/page/room_select_page.dart';
import 'package:porker2fe/presentation/provider/provider.dart';

part 'router.g.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final env = ref.read(envProvider);
  return GoRouter(
    debugLogDiagnostics: !env.isProduction,
    initialLocation: '/',
    routes: $appRoutes,
    redirect: (context, state) {
      final isLoggedIn = ref.read(userProvider.notifier).alreadyLogin;
      final isLoggingIn = state.fullPath == '/';
      final isPoker = state.fullPath == '/poker';

      logger.d(
          'isLoggedIn: $isLoggedIn, isLoggingIn: $isLoggingIn, path: ${state.fullPath}');

      if (!isLoggedIn && !isLoggingIn && !isPoker) {
        return '/';
      }
      return null;
    },
  );
});

@TypedGoRoute<LoginRoute>(
  path: '/',
)
class LoginRoute extends GoRouteData {
  LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginPage();
  }
}

@TypedGoRoute<RoomSelectRoute>(
  path: '/room',
)
class RoomSelectRoute extends GoRouteData {
  RoomSelectRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const RoomSelectPage();
  }
}

@TypedGoRoute<PokerRoute>(
  path: '/poker',
)
class PokerRoute extends GoRouteData {
  PokerRoute({this.roomId = ""});

  final String roomId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PokerPage(roomId);
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:porker2fe/presentation/page/login_page.dart';
import 'package:porker2fe/presentation/page/poker_page.dart';
import 'package:porker2fe/presentation/page/room_select_page.dart';

part 'router.g.dart';

const loginRoute = '/';

final router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: loginRoute,
  routes: $appRoutes,
);

@TypedGoRoute<LoginRoute>(
  path: loginRoute,
)
class LoginRoute extends GoRouteData {
  LoginRoute({this.from = ""});

  final String from; // TODO: sample

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginPage();
  }
}

const roomSelectRoute = '/room';

@TypedGoRoute<RoomSelectRoute>(
  path: roomSelectRoute,
)
class RoomSelectRoute extends GoRouteData {
  RoomSelectRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const RoomSelectPage();
  }
}

const pokerRoute = '/poker';

@TypedGoRoute<PokerRoute>(
  path: pokerRoute,
)
class PokerRoute extends GoRouteData {
  PokerRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PokerPage();
  }
}

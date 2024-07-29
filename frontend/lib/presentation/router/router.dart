import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:porker2fe/presentation/page/login_page.dart';
import 'package:porker2fe/presentation/page/room_select_page.dart';

part 'router.g.dart';

final router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/',
  routes: $appRoutes,
);

@TypedGoRoute<LoginRoute>(path: '/')
class LoginRoute extends GoRouteData {
  LoginRoute({this.from = ""});

  final String from; // TODO: sample

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginPage();
  }
}

@TypedGoRoute<RoomSelectRoute>(path: '/room')
class RoomSelectRoute extends GoRouteData {
  RoomSelectRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const RoomSelectPage();
  }
}

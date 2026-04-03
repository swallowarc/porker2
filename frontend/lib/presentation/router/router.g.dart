// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$loginRoute, $roomSelectRoute, $pokerRoute];

RouteBase get $loginRoute =>
    GoRouteData.$route(path: '/', factory: $LoginRoute._fromState);

mixin $LoginRoute on GoRouteData {
  static LoginRoute _fromState(GoRouterState state) => LoginRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $roomSelectRoute =>
    GoRouteData.$route(path: '/room', factory: $RoomSelectRoute._fromState);

mixin $RoomSelectRoute on GoRouteData {
  static RoomSelectRoute _fromState(GoRouterState state) => RoomSelectRoute();

  @override
  String get location => GoRouteData.$location('/room');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $pokerRoute =>
    GoRouteData.$route(path: '/poker', factory: $PokerRoute._fromState);

mixin $PokerRoute on GoRouteData {
  static PokerRoute _fromState(GoRouterState state) =>
      PokerRoute(roomId: state.uri.queryParameters['room-id'] ?? "");

  PokerRoute get _self => this as PokerRoute;

  @override
  String get location => GoRouteData.$location(
    '/poker',
    queryParams: {if (_self.roomId != "") 'room-id': _self.roomId},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

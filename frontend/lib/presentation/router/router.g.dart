// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $loginRoute,
      $roomSelectRoute,
      $pokerRoute,
    ];

RouteBase get $loginRoute => GoRouteData.$route(
      path: '/',
      factory: $LoginRouteExtension._fromState,
    );

extension $LoginRouteExtension on LoginRoute {
  static LoginRoute _fromState(GoRouterState state) => LoginRoute(
        roomId: state.uri.queryParameters['room-id'] ?? "",
      );

  String get location => GoRouteData.$location(
        '/',
        queryParams: {
          if (roomId != "") 'room-id': roomId,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $roomSelectRoute => GoRouteData.$route(
      path: '/room',
      factory: $RoomSelectRouteExtension._fromState,
    );

extension $RoomSelectRouteExtension on RoomSelectRoute {
  static RoomSelectRoute _fromState(GoRouterState state) => RoomSelectRoute();

  String get location => GoRouteData.$location(
        '/room',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $pokerRoute => GoRouteData.$route(
      path: '/poker',
      factory: $PokerRouteExtension._fromState,
    );

extension $PokerRouteExtension on PokerRoute {
  static PokerRoute _fromState(GoRouterState state) => PokerRoute(
        roomId: state.uri.queryParameters['room-id'] ?? "",
      );

  String get location => GoRouteData.$location(
        '/poker',
        queryParams: {
          if (roomId != "") 'room-id': roomId,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

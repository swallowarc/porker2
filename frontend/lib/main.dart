import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/presentation/page/login_page.dart';
import 'package:porker2fe/presentation/router/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter goRouter = GoRouter(
      routes: $appRoutes,
    );
    return MaterialApp.router(
      routerConfig: goRouter,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: "YuseiMagic",
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: "YuseiMagic",
        useMaterial3: true,
      ),
    );
  }
}

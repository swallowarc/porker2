import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/presentation/router/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy());

  runApp(const ProviderScope(child: Porker2()));
}

class Porker2 extends StatelessWidget {
  const Porker2({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter goRouter = GoRouter(
      routes: $appRoutes,
    );
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
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

import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/presentation/router/router.dart';

/// OS の reduce motion 設定（web では prefers-reduced-motion）が有効でも、
/// カードや画面遷移のアニメーションはアプリの状態伝達に必要なため常に再生する。
class _Porker2Binding extends WidgetsFlutterBinding {
  @override
  bool get disableAnimations => false;
}

void main() {
  _Porker2Binding();
  setUrlStrategy(PathUrlStrategy());

  runApp(const ProviderScope(child: Porker2()));
}

class Porker2 extends HookConsumerWidget {
  const Porker2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(routerProvider),
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
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: false),
        child: child!,
      ),
    );
  }
}

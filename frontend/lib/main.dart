import 'package:flutter/material.dart';
import 'package:porker2fe/presentation/page/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Porker2',
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: "CherryBombOne",
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: "CherryBombOne",
        useMaterial3: true,
      ),
      home: const SignInPage2(),
    );
  }
}

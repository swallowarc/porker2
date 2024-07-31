import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/domain/entity/user.dart';
import 'package:porker2fe/presentation/const.dart';
import 'package:porker2fe/presentation/invoke.dart';
import 'package:porker2fe/presentation/provider/provider.dart';
import 'package:porker2fe/presentation/widget/app_bar.dart';
import 'package:porker2fe/presentation/widget/bottom_bar.dart';
import 'package:porker2fe/presentation/widget/logo.dart';

class MainScreen extends HookConsumerWidget {
  final String title;
  final Widget child;

  const MainScreen({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: Porker2AppBar(title: title),
      body: child,
      bottomNavigationBar: const BottomBar(),
    );
  }
}

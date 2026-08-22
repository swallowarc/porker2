// Smoke test that boots the real Porker2 app via ProviderScope.
//
// Purpose: verify that the root widget builds without throwing during the
// initial frame. Uses the real application entry point so that misconfigured
// providers, missing initializations (e.g. URL strategy), or router setup
// issues surface immediately.
//
// References:
//   - frontend/lib/main.dart
//   - frontend/lib/presentation/router/router.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:porker2fe/main.dart';

void main() {
  testWidgets('Porker2 smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: Porker2()));
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qr_generator_and_scanner/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MainApp());

    // Advance time for the splash timer
    await tester.pumpAndSettle(const Duration(seconds: 4));

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

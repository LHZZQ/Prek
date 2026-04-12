// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:_2025_prek/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../lib/main.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    //There should be a MaterialApp component throughout the entire application
    expect(find.byType(MaterialApp), findsOneWidget);
    //There is at least one Scaffold on the interface
    expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
  });
}

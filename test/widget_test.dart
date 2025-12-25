import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_calendar/main.dart';
import 'package:shared_calendar/core/database/database.dart';
import 'package:shared_calendar/core/database/database_provider.dart';
import 'package:drift/native.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    // Override the database provider with an in-memory implementation for testing
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(
          AppDatabase.forTesting(NativeDatabase.memory()),
        ),
      ],
    );

    // Build our app and trigger a frame.
    // Wrap in UncontrolledProviderScope to inject our test container
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MainApp(),
      ),
    );

    // Verify that the app title "Shared Calendar" or a basic element is present (e.g. Login screen)
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

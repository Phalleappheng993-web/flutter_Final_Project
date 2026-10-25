import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/repair/app.dart';
import 'package:flutter_application_1/repair/artwork_store.dart';

void main() {
  setUp(ArtworkStore.reset);

  testWidgets('onboarding shows the first intro', (tester) async {
    await tester.pumpWidget(const ImagineAiApp());
    expect(find.text('Describe what you imagine'), findsOneWidget);
  });

  testWidgets('Skip opens login', (tester) async {
    await tester.pumpWidget(const ImagineAiApp());
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome to Imagine AI'), findsOneWidget);
  });

  testWidgets('login can generate and open the result screen', (tester) async {
    await tester.pumpWidget(const ImagineAiApp());
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'alex@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.ensureVisible(find.text('Continue'));
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextField).first,
      'A fox reading in a library',
    );
    await tester.scrollUntilVisible(
      find.text('Generate image'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Generate image'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Your image'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('A fox reading in a library'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('A fox reading in a library'), findsOneWidget);
  });
}

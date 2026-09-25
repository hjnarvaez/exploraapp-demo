import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:exploraec/main.dart';

void main() {
  testWidgets('muestra una sola pantalla de bienvenida', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ExploraEcApp());

    expect(find.byType(BienvenidaScreen), findsOneWidget);
    expect(find.byIcon(Icons.explore_rounded), findsOneWidget);
    expect(find.text('ExploraEC'), findsOneWidget);
    expect(
      find.text('Descubre y guarda lugares cerca de ti'),
      findsOneWidget,
    );
    expect(find.widgetWithText(FilledButton, 'Empezar'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Empezar'));
    await tester.pump();

    expect(find.byType(BienvenidaScreen), findsOneWidget);
  });
}

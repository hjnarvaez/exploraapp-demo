import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:exploraec/main.dart';

void main() {
  testWidgets('ExploraEC inicia correctamente', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ExploraEcApp());
    await tester.pump();

    // La aplicación raíz debe contener un MaterialApp.
    expect(find.byType(MaterialApp), findsOneWidget);

    // No debe producir excepciones al iniciar.
    expect(tester.takeException(), isNull);
  });
}
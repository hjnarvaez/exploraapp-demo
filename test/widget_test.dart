import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:exploraec/main.dart';

void main() {
  testWidgets('ExploraEC inicia correctamente', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ExploraEcApp());

    // Avanza el tiempo suficiente para que termine
    // fetchLugaresSimulado(), que espera 1 segundo.
    await tester.pump(const Duration(seconds: 1));

    // Procesa los rebuilds provocados por GetX/Obx.
    await tester.pumpAndSettle();

    // La aplicación raíz debe contener un MaterialApp.
    expect(find.byType(MaterialApp), findsOneWidget);

    // No debe producir excepciones al iniciar.
    expect(tester.takeException(), isNull);
  });
}
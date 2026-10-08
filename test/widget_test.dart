import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:exploraec/main.dart';
import 'package:exploraec/services/settings_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory directorioTemporal;

  setUpAll(() async {
    // Hive utiliza una carpeta temporal para las pruebas.
    directorioTemporal =
        await Directory.systemTemp.createTemp('exploraec_test_');

    Hive.init(directorioTemporal.path);

    // Abrir las cajas que necesita ExploraEcApp.
    await Hive.openBox<Map>('favoritos');
    await SettingsService.abrir();
  });

  tearDownAll(() async {
    // Cerrar las cajas y eliminar los datos temporales.
    await Hive.close();

    if (await directorioTemporal.exists()) {
      await directorioTemporal.delete(recursive: true);
    }
  });

  testWidgets('ExploraEC inicia correctamente', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ExploraEcApp());

    // Esperar la carga simulada de lugares.
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Verificar que la aplicación Material se construye.
    expect(find.byType(MaterialApp), findsOneWidget);

    // Comprobar que no existen excepciones.
    expect(tester.takeException(), isNull);
  });
}

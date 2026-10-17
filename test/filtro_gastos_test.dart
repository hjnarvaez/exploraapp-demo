import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:exploraec/controllers/auth_controller.dart';
import 'package:exploraec/controllers/gastos_controller.dart';
import 'package:exploraec/screens/gastos_screen.dart';
import 'package:exploraec/services/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class _BackendGastos implements HttpClientAdapter {
  static var _siguienteUsuario = 0;

  final int idUsuario = ++_siguienteUsuario;
  final gastos = <Map<String, dynamic>>[
    {
      'id': 1,
      'descripcion': 'Almuerzo',
      'monto': 8.5,
      'categoria': 'comida',
      'fecha': '2026-10-17',
    },
    {
      'id': 2,
      'descripcion': 'Taxi al hotel',
      'monto': 4,
      'categoria': 'transporte',
      'fecha': '2026-10-17',
    },
  ];
  bool sinConexion = false;

  ResponseBody _json(Object cuerpo, int codigo,
      [Map<String, List<String>> cabeceras = const {}]) {
    return ResponseBody.fromString(
      jsonEncode(cuerpo),
      codigo,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
        ...cabeceras,
      },
    );
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions opciones,
    Stream<Uint8List>? cuerpo,
    Future<void>? cancelar,
  ) async {
    if (opciones.path == '/usuarios/token') {
      return _json(
          {'access_token': 'token-prueba', 'token_type': 'bearer'}, 200);
    }
    if (opciones.path == '/usuarios/me') {
      return _json({'id': idUsuario, 'email': 'persona@ejemplo.com'}, 200);
    }
    if (opciones.path == '/gastos/categorias') {
      return _json({
        'categorias': ['comida', 'transporte', 'entretenimiento'],
        'limite_por_categoria': 500,
      }, 200);
    }
    if (opciones.path == '/gastos/' && opciones.method == 'GET') {
      if (sinConexion) {
        throw DioException.connectionError(
          requestOptions: opciones,
          reason: 'Servidor no disponible',
        );
      }
      return _json(gastos, 200, {
        'x-total-count': ['${gastos.length}'],
      });
    }
    return _json({'detail': 'Ruta no prevista: ${opciones.path}'}, 404);
  }

  @override
  void close({bool force = false}) {}
}

Future<void> _esperarCarga(GastosController controller) async {
  for (var intento = 0;
      intento < 200 && controller.gastos.length < 2;
      intento++) {
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}

Future<({GastosController controller, _BackendGastos backend})>
    _montar() async {
  Get.reset();
  Get.testMode = true;
  FlutterSecureStorage.setMockInitialValues({});

  final backend = _BackendGastos();
  final dio = Dio(BaseOptions(baseUrl: 'http://prueba'))
    ..httpClientAdapter = backend;
  final api = Get.put(ApiClient(dio: dio));
  final auth = Get.put(AuthController(api: api));
  await auth.iniciarSesion('persona@ejemplo.com', 'clave-1234');
  final controller = Get.put(GastosController());
  await _esperarCarga(controller);
  return (controller: controller, backend: backend);
}

void main() {
  setUpAll(() {
    Hive.init(Directory.systemTemp.createTempSync('hive_filtro_gastos').path);
  });

  tearDown(Get.reset);

  testWidgets(
      'al elegir comida se muestran solamente los gastos de esa categoría',
      (tester) async {
    final montaje = await tester.runAsync(_montar);
    final controller = montaje!.controller;

    await tester.pumpWidget(const GetMaterialApp(home: GastosScreen()));
    await tester.pump();

    expect(find.widgetWithText(ChoiceChip, 'Todas'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'comida'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'transporte'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'entretenimiento'), findsNothing);
    expect(find.text('Almuerzo'), findsOneWidget);
    expect(find.text('Taxi al hotel'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'comida'));
    await tester.pump();

    expect(find.text('Almuerzo'), findsOneWidget);
    expect(find.text('Taxi al hotel'), findsNothing);
    expect(controller.gastos, hasLength(2));

    await tester.tap(find.widgetWithText(ChoiceChip, 'Todas'));
    await tester.pump();

    expect(find.text('Almuerzo'), findsOneWidget);
    expect(find.text('Taxi al hotel'), findsOneWidget);
  });

  testWidgets('el filtro funciona con gastos recuperados de la caché local',
      (tester) async {
    final montaje = await tester.runAsync(_montar);
    final controller = montaje!.controller;
    montaje.backend.sinConexion = true;
    await tester.runAsync(controller.cargarGastos);

    await tester.pumpWidget(const GetMaterialApp(home: GastosScreen()));
    await tester.pump();
    expect(
        find.textContaining('Sin conexión — gastos guardados'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'comida'));
    await tester.pump();

    expect(find.text('Almuerzo'), findsOneWidget);
    expect(find.text('Taxi al hotel'), findsNothing);
    expect(controller.desdeCache.value, isTrue);
    expect(controller.gastos, hasLength(2));
  });
}

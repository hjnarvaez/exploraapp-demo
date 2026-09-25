import 'package:flutter/material.dart';
import 'bienvenida_codex_design.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BienvenidaScreenCodexDesign(),
  ));
}

class ExploraEcApp extends StatelessWidget {
  const ExploraEcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExploraEC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const BienvenidaScreen(),
    );
  }
}

class BienvenidaScreen extends StatelessWidget {
  
  const BienvenidaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.explore_rounded,
                    size: 96,
                    color: colorScheme.primary,
                    semanticLabel: 'Explorar lugares',
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'ExploraEC',
                    textAlign: TextAlign.center,
                    style: textTheme.displaySmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Descubre y guarda lugares cerca de ti',
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {},
                      child: const Text('Empezar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class BienvenidaScreenCodexDesign extends StatelessWidget {
  const BienvenidaScreenCodexDesign({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primaryContainer,
              colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withValues(alpha: 0.75),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Icon(
                        Icons.travel_explore_rounded,
                        size: 48,
                        color: colorScheme.primary,
                        semanticLabel: 'Explorar lugares',
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'ExploraEC',
                  style: textTheme.displayMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Descubre y guarda lugares cerca de ti',
                  style: textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 40),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text('Empezar'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

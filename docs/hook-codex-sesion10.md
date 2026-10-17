# Sesión 10 — Hook de formateo con Codex

## Objetivo

Ejecutar automáticamente `dart format lib test` después de una edición realizada por Codex mediante `apply_patch`.

## Entorno

- Codex CLI 0.163.0
- Proyecto Flutter ExploraEC
- Rama: `opcionales-sesion10`

## Configuración comprobada

El hook se cargó utilizando el siguiente comando:

```bash
codex -c 'hooks.PostToolUse=[{matcher="apply_patch",hooks=[{type="command",command="dart format lib test",timeout=60}]}]'
```

## Evidencias

- Codex reconoció un hook PostToolUse.
- El hook fue revisado y autorizado.
- Se mostró el estado Trusted.
- Codex agregó un comentario en gastos_screen.dart usando apply_patch.
- El formateador modificó archivos de lib y test.
- Se descartaron los cambios de formato no relacionados.
- flutter analyze: sin observaciones.
- flutter test: 31 pruebas aprobadas.

## Limitación identificada

No se confirmó la carga automática desde .codex/config.toml.
La ejecución se demostró mediante configuración explícita de Codex.

## Recomendación

Limitar el formateo a los archivos modificados para evitar cambios innecesarios.

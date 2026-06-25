# Instrucciones para agentes

Antes de implementar, leer `docs/README.md` y respetar sus decisiones.

Los skills locales se encuentran en `.agent/skills/`. Cargar solo los que sean
pertinentes para la tarea:

- Flutter/Dart: `flutter-expert`.
- Diseño de pantallas: `mobile-design`.
- SQLite y esquema: `database-design`.
- Seguridad, login o biometría: `mobile-security-coder` y `privacy-by-design`.
- Accesibilidad: `accessibility-compliance-accessibility-audit`.
- Nuevas funcionalidades o correcciones: `test-driven-development`.
- Fallos: `systematic-debugging`.
- Revisión: `code-review-checklist`.
- Decisiones estructurales: `architecture-decision-records`.
- Antes de declarar una tarea terminada: `verification-before-completion`.

La documentación del proyecto prevalece sobre ejemplos genéricos incluidos en
los skills. No ejecutar scripts auxiliares sin revisar antes su alcance.

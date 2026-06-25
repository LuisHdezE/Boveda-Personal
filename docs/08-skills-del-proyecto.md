# Skills del proyecto

## Ubicación

Los skills están versionados en [`.agent/skills`](../.agent/skills). Se eligió
esta convención portable porque la carpeta `.agents` existente está protegida
como solo lectura en el entorno.

## Criterios de selección

Se revisaron los catálogos según estas necesidades del proyecto:

- Flutter y Dart para Android.
- Arquitectura por funcionalidades y Riverpod.
- Persistencia offline con SQLite.
- Importes monetarios y datos financieros sensibles.
- Autenticación local, almacenamiento seguro y biometría.
- Material Design 3, experiencia móvil y accesibilidad.
- Pruebas, diagnóstico, revisión y documentación de decisiones.

Se excluyeron skills orientados a web, backend, nube, React Native, iOS puro,
marketing, agentes autónomos y pruebas ofensivas. También se descartaron
duplicados o paquetes que exigían herramientas ajenas al proyecto.

## Skills incorporados

| Skill | Uso en Bóveda Personal | Fuente |
| --- | --- | --- |
| `flutter-expert` | Desarrollo Flutter, Riverpod, Material 3 y rendimiento | Antigravity |
| `flutter-development` | Patrones Flutter básicos y navegación | Agentpedia / aj-geddes |
| `mobile-design` | Diseño móvil, touch, offline y estados | Antigravity |
| `mobile-security-coder` | Seguridad local y biometría | Antigravity |
| `privacy-by-design` | Protección y minimización de datos | Antigravity |
| `database-design` | Modelo SQLite, índices y migraciones | Antigravity |
| `accessibility-compliance-accessibility-audit` | Auditoría accesible | Antigravity |
| `test-driven-development` | Implementación guiada por pruebas | Antigravity |
| `systematic-debugging` | Investigación de causa raíz | Antigravity |
| `verification-before-completion` | Verificación antes del cierre | Antigravity |
| `code-review-checklist` | Revisión integral de cambios | Antigravity |
| `architecture-decision-records` | Registro de decisiones | Antigravity |

## Adaptaciones necesarias

- La arquitectura documentada del proyecto prevalece sobre ejemplos genéricos.
- Riverpod es la opción preferida aunque `flutter-development` muestre Provider.
- `database-design` incluye ejemplos de bases servidoras y ORM; para este
  proyecto se utiliza únicamente su razonamiento aplicable a SQLite/sqflite.
- Los scripts de auditoría son opcionales. Algunos mezclan comprobaciones de
  React Native y Flutter y pueden producir falsos positivos.
- Las referencias a red, APIs o sincronización no alteran el requisito de
  funcionamiento completamente offline.

## Seguridad y procedencia

Se inspeccionaron los archivos y scripts auxiliares antes de copiarlos. No se
encontraron operaciones automáticas de descarga, envío de datos o modificación
destructiva dentro de la selección.

Las licencias se conservan en [`docs/licenses`](licenses):

- Antigravity: MIT para código y CC BY 4.0 para contenido original no código.
- `useful-ai-prompts`: MIT.

Agentpedia funciona como índice editorial y enlaza a repositorios originales.
Un skill de generación de casos de prueba fue descartado porque su declaración
interna indicaba MIT mientras el repositorio fuente estaba licenciado AGPL-3.0;
se evitó incorporar material con procedencia ambigua.

## Uso recomendado por etapa

| Etapa | Skills |
| --- | --- |
| Fundaciones | `flutter-expert`, `architecture-decision-records` |
| UI y navegación | `mobile-design`, `flutter-development`, accesibilidad |
| Persistencia | `database-design`, `privacy-by-design` |
| Login y biometría | `mobile-security-coder`, `privacy-by-design` |
| Implementación | `test-driven-development` |
| Incidencias | `systematic-debugging` |
| Entrega | `code-review-checklist`, `verification-before-completion` |

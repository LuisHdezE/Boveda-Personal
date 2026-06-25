# Skills del proyecto

Esta colección contiene skills de terceros seleccionados para el desarrollo de
Bóveda Personal. Cada subdirectorio conserva su `SKILL.md` y los recursos
necesarios para usarlo.

## Flutter y experiencia móvil

- `flutter-expert`: implementación avanzada con Flutter, Dart, Riverpod,
  Material 3, rendimiento y accesibilidad.
- `flutter-development`: patrones básicos de composición y navegación. Sus
  ejemplos con Provider son orientativos; Bóveda Personal prioriza Riverpod.
- `mobile-design`: diseño touch-first, estados offline, navegación y
  restricciones móviles.
- `accessibility-compliance-accessibility-audit`: auditorías de accesibilidad.

## Datos, privacidad y seguridad

- `database-design`: esquemas, relaciones, índices y migraciones; adaptar las
  recomendaciones a SQLite/sqflite.
- `mobile-security-coder`: almacenamiento seguro, autenticación local,
  biometría y protección de datos en dispositivos.
- `privacy-by-design`: minimización de datos, retención, borrado y logs.

## Calidad y mantenimiento

- `test-driven-development`: ciclo prueba-fallo-implementación-refactorización.
- `systematic-debugging`: diagnóstico basado en causa raíz.
- `verification-before-completion`: evidencia antes de declarar una tarea
  terminada.
- `code-review-checklist`: revisión funcional, de seguridad, rendimiento y
  mantenibilidad.
- `architecture-decision-records`: registro de decisiones técnicas importantes.

## Precedencia

Los skills son material auxiliar. En caso de conflicto se aplica este orden:

1. Solicitud explícita del usuario.
2. Documentación de `docs/`.
3. Decisiones registradas en ADR.
4. Skills del proyecto.

No se deben ejecutar scripts auxiliares automáticamente. Primero hay que
revisar su contenido y comprobar que sean pertinentes para Flutter y Windows.

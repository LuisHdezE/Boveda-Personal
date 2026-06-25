# ADR-0002: Dependencias base y límites

## Estado

Aceptada — 2026-06-25.

## Contexto

El proyecto necesita estado, almacenamiento, seguridad, biometría, gráficos,
localización y pruebas. Añadir paquetes sin uso aumenta superficie de ataque,
tamaño y mantenimiento.

## Decisión

- Riverpod para estado e inyección.
- `go_router` para navegación.
- `sqflite` para SQLite.
- `flutter_secure_storage`, `cryptography` y `local_auth` para seguridad.
- `decimal` para cálculos monetarios exactos.
- `fl_chart` para gráficos.
- Freezed y JSON Serializable solo donde reduzcan código repetitivo real.
- Mocktail, SQLite FFI y Golden Toolkit para pruebas.

No se incluyen clientes HTTP, Firebase, analytics, crash reporting, nube ni
sincronización porque contradicen el alcance offline actual.

## Consecuencias

- El conjunto inicial cubre toda la arquitectura prevista.
- Cada dependencia debe justificar su permanencia mediante uso real.
- Las versiones se fijarán definitivamente en `pubspec.lock` al ejecutar
  `flutter pub get` con Flutter 3.44.4.
- Android tendrá `minSdk 24`, permiso biométrico y una actividad basada en
  `FlutterFragmentActivity`, requisitos aplicados por el bootstrap.

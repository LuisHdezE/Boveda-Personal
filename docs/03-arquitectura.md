# Arquitectura propuesta

## Base tecnológica

- Flutter y Dart en una versión estable fijada por el proyecto.
- SQLite mediante `sqflite`.
- Almacenamiento seguro para secretos y claves.
- Riverpod para estado e inyección de dependencias.
- `fl_chart` para visualizaciones.
- Paquetes de localización y formato para fechas, números y monedas.

Las versiones concretas se fijarán al crear el proyecto Flutter; no se debe
depender de “la última versión” sin registrarla.

## Organización por funcionalidades

```text
lib/
  app/                 # arranque, rutas, tema y dependencias globales
  core/                # base de datos, seguridad, dinero, errores, utilidades
  features/
    onboarding/
    auth/
    dashboard/
    movements/
    reports/
    simulator/
    converter/
    settings/
  shared/              # componentes reutilizables sin reglas de una feature
```

Cada funcionalidad puede separar:

```text
data/          # SQLite, DTO y repositorios concretos
domain/        # entidades, reglas y contratos
presentation/  # pantallas, controladores y widgets
```

## Decisiones de diseño técnico

- La interfaz no consulta SQLite directamente.
- Los repositorios concentran persistencia y consultas.
- Los casos de uso encapsulan operaciones que afectan varias tablas.
- Los contratos de repositorio viven en dominio y sus implementaciones en
  `data`.
- Los casos de uso públicos se exportan desde `lib/use_cases.dart`.
- Conversiones, edición y eliminación se ejecutan en transacciones SQLite.
- El dinero se representa en unidades menores enteras cuando la moneda lo
  permita, o mediante decimal serializado con escala explícita.
- Las fechas se guardan en UTC y se presentan en la zona local.
- Los identificadores son estables y no dependen de posiciones en listas.
- Los gráficos reciben series ya agregadas, no filas crudas de la base.

## Seguridad local

- La contraseña se verifica con un hash derivado resistente y salt único.
- El almacenamiento seguro guarda material sensible, no todos los datos.
- La biometría desbloquea una credencial local; no sustituye el mecanismo de
  autenticación ni permite recuperar una contraseña olvidada.
- Los logs no deben contener importes, credenciales ni notas privadas.
- Se debe definir una política explícita de borrado/restablecimiento local.

## Pruebas mínimas

- Unitarias para dinero, tasas, ahorro, períodos y proyecciones.
- Repositorios contra una base SQLite temporal.
- Widgets para formularios, estados vacíos y navegación.
- Integración para alta inicial, login, movimiento, conversión y restauración
  de saldos tras editar/eliminar.
- Migraciones de base de datos probadas desde cada versión soportada.

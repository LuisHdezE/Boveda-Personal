# Base de datos

## Decisiones

- SQLite mediante `sqflite`.
- Esquema actual: versión 1.
- Fechas UTC como milisegundos Unix (`INTEGER`).
- Importes como unidades menores (`INTEGER`).
- Tasas exactas como texto decimal canónico (`TEXT`).
- Saldos derivados mediante la vista `account_balances`.
- Claves foráneas activadas en cada conexión.
- Borrado seguro de páginas SQLite activado.
- Migraciones incrementales; no se aceptan downgrades implícitos.

## Objetos

Tablas:

- `users`
- `settings`
- `accounts`
- `categories`
- `transfers`
- `movements`
- `exchange_rates`
- `calculator_currencies`
- `simulation_history`

Vista:

- `account_balances`

El esquema fuente se encuentra en
[`lib/core/database/database_schema.dart`](../../lib/core/database/database_schema.dart).

## Integridad

- Las monedas se guardan normalizadas en mayúsculas.
- Importes de movimientos y transferencias son positivos.
- El signo financiero se deriva del tipo de movimiento.
- Una transferencia exige cuentas diferentes.
- Sus movimientos deben apuntar a las cuentas origen/destino correctas.
- Las categorías del sistema no se eliminan.
- Categorías y cuentas con historial están protegidas por claves foráneas.
- Eliminar una transferencia elimina sus dos movimientos vinculados.

## Migraciones

Cada nueva versión debe:

1. añadir un caso incremental en `DatabaseMigrator`;
2. conservar datos existentes;
3. actualizar `DatabaseSchema.version`;
4. incluir prueba desde todas las versiones soportadas;
5. documentar rollback o recuperación.

No editar una migración publicada: crear una nueva.

## Seeds

La versión 1 crea categorías básicas de ingreso y gasto con IDs estables. Se
insertan mediante `INSERT OR IGNORE`, por lo que abrir la base repetidamente no
genera duplicados.

## Pruebas

Las pruebas usan SQLite real en memoria mediante `sqflite_common_ffi`; no mocks.
Cubren creación, versión, claves foráneas, seeds, vista de saldo, restricciones,
rollback y migraciones.

## Acceso a datos

Los DAOs en `lib/core/database/dao/` ofrecen:

- cuentas y saldos;
- categorías;
- movimientos filtrados y paginados;
- transferencias atómicas;
- historial de tasas;
- usuario y configuración;
- monedas de calculadora;
- historial de simulaciones.

Devuelven filas SQLite explícitas. Los repositorios de cada feature serán
responsables de mapearlas a entidades de dominio.

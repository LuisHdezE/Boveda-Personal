# Modelo de datos

El esquema SQLite definitivo de la versión 1 está implementado en
[`lib/core/database/database_schema.dart`](../lib/core/database/database_schema.dart).
Este documento conserva la vista conceptual del modelo.

Las clases Dart y sus reglas están catalogadas en
[`models/README.md`](models/README.md).

El dominio también incluye modelos no persistidos para sesión, biometría,
onboarding, filtros, dashboard, reportes, conversión y proyección. Estos no
generan tablas porque representan comandos, consultas o resultados derivados.

## Entidades

### `users`

- `id`
- `display_name`
- `username` (único)
- `password_hash`
- `password_salt`
- `created_at`
- `updated_at`

Los importes se almacenan en unidades menores enteras y las tasas como texto
decimal. Véase [`database/README.md`](database/README.md).

### `settings`

- `id`
- `primary_currency_code`
- `locale`
- `biometrics_enabled`
- `auto_lock_duration`
- `onboarding_completed`
- `created_at`
- `updated_at`

### `accounts`

Aunque la especificación original no la enumera, conviene modelar una cuenta
por moneda para evitar saldos duplicados en configuración.

- `id`
- `currency_code`
- `name`
- `is_active`
- `created_at`

El saldo se deriva de movimientos; no debe mantenerse como una cifra
independiente sin una estrategia transaccional.

### `categories`

- `id`
- `name`
- `icon`
- `color`
- `movement_type` (`income`, `expense` o ambos)
- `is_system`
- `is_active`

### `movements`

- `id`
- `account_id`
- `category_id` (opcional para ajustes o conversiones)
- `type` (`opening`, `income`, `expense`, `transfer_in`, `transfer_out`,
  `adjustment`)
- `amount`
- `occurred_at`
- `note`
- `transfer_id` (opcional)
- `created_at`
- `updated_at`

### `transfers`

Representa una conversión entre cuentas como una sola operación lógica.

- `id`
- `source_account_id`
- `destination_account_id`
- `source_amount`
- `destination_amount`
- `exchange_rate`
- `occurred_at`
- `note`

### `exchange_rates`

- `id`
- `base_currency_code` (normalmente `USD`)
- `quote_currency_code`
- `rate`
- `effective_at`
- `created_at`

### `calculator_currencies`

- `id`
- `name`
- `code` (único)
- `symbol`
- `units_per_usd`
- `is_active`
- `updated_at`

### `simulation_history`

- `id`
- `currency_code`
- `initial_balance`
- `monthly_income`
- `monthly_expense`
- `duration_months`
- `projected_balance`
- `created_at`

## Relaciones

```text
accounts 1 ── * movements * ── 0..1 categories
accounts 1 ── * transfers * ── 1 accounts
transfers 1 ── 2 movements
exchange_rates y calculator_currencies → cálculos de conversión
```

## Índices previstos

- `movements(occurred_at)`
- `movements(account_id, occurred_at)`
- `movements(category_id, occurred_at)`
- `movements(type, occurred_at)`
- `exchange_rates(base_currency_code, quote_currency_code, effective_at)`

## Integridad

- Importes positivos; el signo se deriva del tipo.
- Códigos de moneda normalizados en mayúsculas.
- Tasas mayores que cero.
- Una transferencia tiene cuentas diferentes y dos movimientos vinculados.
- No se eliminan categorías o monedas con historial: se desactivan.

# Modelos

## Separación

- **Objetos de valor:** `Currency` y `Money`.
- **Entidades de dominio:** no conocen Flutter, SQLite ni mapas.
- **Modelos SQLite:** convierten filas a entidades y viceversa.
- **Read models:** representan vistas derivadas, como `AccountBalance`.

No se utiliza generación automática para estas clases fundamentales. Esto
mantiene visible la semántica de igualdad, copia y seguridad.

## Entidades

| Entidad | Ubicación |
| --- | --- |
| `User` | `features/auth/domain/entities` |
| `AppSettings` | `features/settings/domain/entities` |
| `Account` / `AccountBalance` | `features/accounts/domain/entities` |
| `Category` | `features/categories/domain/entities` |
| `Movement` / `Transfer` | `features/movements/domain/entities` |
| `ExchangeRate` | `features/rates/domain/entities` |
| `CalculatorCurrency` | `features/converter/domain/entities` |
| `SimulationHistory` | `features/simulator/domain/entities` |

## Objetos funcionales no persistidos

| Área | Objetos |
| --- | --- |
| Tiempo | `DateRange`, `PeriodUnit` |
| Paginación | `PageRequest`, `Page<T>` |
| Autenticación | `AuthSession`, `BiometricStatus`, credenciales y cambio de contraseña |
| Onboarding | `OnboardingSetup` |
| Movimientos | `MovementFilter`, `MovementDraft`, `TransferDraft` |
| Tasas | `ExchangeRateUpdate` |
| Dashboard | `DashboardSnapshot`, `WealthPoint` |
| Reportes | `FinancialReport`, `CategoryBreakdown`, `CashFlowPoint`, `NetWorthPoint` |
| Conversor | `ConversionRequest`, `ConversionQuote` |
| Simulador | `SimulationInput`, `ProjectionPoint`, `SimulationResult` |
| Perfil | `ProfileUpdate` |

El archivo [`lib/models.dart`](../../lib/models.dart) permite importar todas
las entidades públicas desde un solo lugar.

## Reglas

- Fechas de persistencia se normalizan a UTC.
- Códigos de moneda se exponen en mayúsculas.
- `Money` opera únicamente entre monedas y escalas iguales.
- `Movement` calcula el signo desde su tipo.
- Los secretos de `User` participan en igualdad y persistencia, pero nunca en
  `toString`.
- Los mappers rechazan columnas ausentes o de tipo inesperado.
- Las entidades son inmutables y ofrecen `copyWith` cuando pueden editarse.
- Los comandos de contraseña nunca muestran secretos en `toString`.
- Rangos temporales usan inicio inclusivo y fin exclusivo.
- Series financieras deben estar ordenadas y utilizar una sola moneda.
- Los objetos derivados no se persisten salvo que exista una tabla explícita.

## Persistencia

Los modelos de `data/models` implementan:

```text
entidad → fromEntity → modelo → toRow → SQLite
SQLite → fromRow → modelo → toEntity → entidad
```

`MovementModel` y `TransferModel` reciben la moneda desde las cuentas
relacionadas porque las filas de movimientos no duplican código ni escala.

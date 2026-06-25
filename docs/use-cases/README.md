# Casos de uso

La capa de aplicación está en `features/*/domain/use_cases`. Orquesta entidades
y repositorios, pero no conoce SQLite, widgets ni plugins Android.

## Catálogo

### Onboarding

- `ConfigureApplication`: crea usuario, configuración, dos cuentas, tasa
  inicial y movimientos de apertura mediante una única operación de repositorio.

### Autenticación y seguridad

- `Login`
- `ChangePassword`
- `GetBiometricStatus`
- `EnableBiometrics`
- `DisableBiometrics`
- `UnlockWithBiometrics`
- `EvaluateSessionLock`
- `RegisterSessionActivity`
- `Logout`

### Cuentas y categorías

- `ListAccounts`
- `GetAccount`
- `GetAccountBalances`
- `SetAccountActive`
- `ListCategories`
- `SaveCategory`
- `SetCategoryActive`

### Movimientos y transferencias

- `CreateMovement`
- `GetMovement`
- `ListMovements`
- `UpdateMovement`
- `DeleteMovement`
- `ExecuteTransfer`
- `ReplaceTransfer`
- `DeleteTransfer`

### Tasas y conversión

- `UpdateExchangeRate`
- `GetLatestExchangeRate`
- `ListExchangeRates`
- `ConvertCurrency`
- `ListCalculatorCurrencies`
- `SaveCalculatorCurrency`
- `SetCalculatorCurrencyActive`

### Análisis

- `BuildDashboard`
- `GenerateFinancialReport`

Ambos reciben un `MoneyConverter`, por lo que nunca suman monedas diferentes
sin una conversión explícita.

### Simulación

- `RunSimulation`
- `SaveSimulation`
- `ListSimulationHistory`
- `DeleteSimulationHistory`

### Configuración

- `UpdateProfile`
- `SaveSettings`
- `LoadSettings`
- `GetAppMetadata`

## Puertos

Los límites externos se expresan como contratos:

- repositorios por feature;
- `PasswordHasher`;
- `IdGenerator`;
- `MoneyConverter`;
- `AppMetadataProvider`;
- repositorio biométrico.

Las implementaciones SQLite y Android pertenecen a `data`, no a los casos de
uso.

## Errores

Los casos de uso lanzan subtipos de `AppFailure`:

- `ValidationFailure`
- `NotFoundFailure`
- `ConflictFailure`
- `AuthenticationFailure`
- `StorageFailure`

La presentación traduce estos códigos a mensajes localizados. No se incluyen
textos de UI dentro del dominio.

## Seguridad

- Login ejecuta verificación de hash incluso para un usuario inexistente.
- Contraseñas nunca aparecen en `toString`.
- Cambio de contraseña genera hash y salt nuevos antes de persistir.
- Biometría guarda solo un identificador local protegido, no la contraseña.

## Importaciones

- [`lib/use_cases.dart`](../../lib/use_cases.dart): casos de uso públicos.
- [`lib/repositories.dart`](../../lib/repositories.dart): contratos.
- [`lib/models.dart`](../../lib/models.dart): objetos de dominio.

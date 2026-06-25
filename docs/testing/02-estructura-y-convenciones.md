# Estructura y convenciones

## Árbol previsto

```text
test/
  helpers/
    builders/
    fakes/
    matchers/
    clocks/
  core/
    money/
    date/
    validation/
    security/
    logging/
  features/
    onboarding/
    auth/
    accounts/
    categories/
    movements/
    dashboard/
    reports/
    converter/
    simulator/
    settings/
  app/
    routing/
```

Los tests reflejan `lib/`. Un archivo de producción
`lib/features/movements/domain/use_cases/create_movement.dart` tendrá
`test/features/movements/domain/use_cases/create_movement_test.dart`.

## Convención de nombres

```dart
group('CreateMovement', () {
  test('MOV-001 registra un ingreso válido', () async {});
  test('MOV-005 rechaza una categoría incompatible', () async {});
});
```

- El ID del catálogo forma parte del nombre.
- Un test demuestra un comportamiento observable.
- El nombre evita detalles privados de implementación.
- Para matrices se utiliza un caso por fila con etiqueta descriptiva.

## Patrón Arrange–Act–Assert

```dart
test('MONEY-004 suma importes de la misma moneda exactamente', () {
  final left = Money.minor(10, currency: usd);
  final right = Money.minor(25, currency: usd);

  final result = left + right;

  expect(result, Money.minor(35, currency: usd));
});
```

## Dobles permitidos

Preferir fakes en memoria:

- `FakeClock`
- `FakeIdGenerator`
- `InMemoryMovementRepository`
- `InMemoryAccountRepository`
- `FakePasswordHasher`
- `FakeSecureStorage`
- `FakeBiometricGateway`
- `SpyTransactionRunner`
- `CollectingSafeLogger`

Usar mocks solo para verificar límites externos o fallos difíciles de producir.
No comprobar interacciones internas si puede comprobarse el resultado real.

## Dependencias inyectables obligatorias

- Reloj.
- Generador de IDs.
- Repositorios.
- Ejecutor transaccional.
- Hasher de contraseñas.
- Almacenamiento seguro.
- Gateway biométrico.
- Logger.
- Proveedor de metadatos de la aplicación.

Sin estas fronteras, las pruebas serían frágiles o dependerían del dispositivo.

## TDD por caso

1. Elegir el siguiente ID.
2. Escribir el test y confirmar que falla por la razón esperada.
3. Implementar el comportamiento mínimo.
4. Ejecutar el archivo afectado.
5. Refactorizar manteniendo verde.
6. Ejecutar toda la suite y cobertura.

No se crea un bloque entero de producción para después “cubrirlo”.

## Qué excluir de cobertura

Solo archivos generados:

- `*.g.dart`
- `*.freezed.dart`
- localización generada
- registradores de plugins generados

No se excluyen modelos, mappers, providers, rutas ni manejo de errores para
alcanzar artificialmente el porcentaje.

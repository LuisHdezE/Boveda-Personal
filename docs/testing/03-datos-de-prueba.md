# Datos de prueba

## Monedas

| Fixture | Código | Escala | Tasa ilustrativa |
| --- | --- | --- | --- |
| `usd` | USD | 2 | 1 USD |
| `peso` | `PENDIENTE` | 2 | 40 unidades/USD |
| `jpy` | JPY | 0 | 150 unidades/USD |
| `kwd` | KWD | 3 | 0.307 unidades/USD |

JPY y KWD obligan a probar escalas distintas aunque no sean cuentas principales.

## Importes frontera

- Cero.
- Una unidad menor.
- Un importe con separador regional.
- Un importe que exige redondeo por debajo, igual y por encima de la mitad.
- Máximo seguro y máximo + 1.
- Serie de 10 000 sumas de una unidad menor.
- Tasa muy pequeña y tasa muy grande.

## Fechas

- `2026-01-01T00:00:00Z`.
- Último instante de mes y primer instante del siguiente.
- `2024-02-29` como año bisiesto.
- Diciembre→enero.
- Todos los inicios de trimestre.
- Dos instantes UTC que pertenecen a días locales diferentes.
- Instantes exactamente en cada límite `[inicio, fin)`.

Todas las pruebas reciben `FakeClock`; ninguna usa `DateTime.now()`.

## Builders

Cada builder genera un objeto válido por defecto y permite modificar solo el
campo relevante:

```dart
movementBuilder(
  type: MovementType.expense,
  amount: usdMoney('10.00'),
  occurredAt: fixedNow,
);
```

Builders previstos:

- `userBuilder`
- `settingsBuilder`
- `accountBuilder`
- `categoryBuilder`
- `movementBuilder`
- `transferBuilder`
- `exchangeRateBuilder`
- `calculatorCurrencyBuilder`
- `simulationBuilder`

## Escenarios financieros canónicos

### Cuenta vacía

USD = 0; pesos = 0.

### Flujo mensual

- Apertura USD 1 000.
- Ingreso USD 500.
- Gasto USD 125.25.
- Transferencia USD 100 → pesos a tasa 40.

Resultados:

- USD: 1 274.75.
- Pesos: 4 000.
- Ingreso mensual: 500.
- Gasto mensual: 125.25.
- Ahorro mensual: 374.75.
- La transferencia no altera ingreso, gasto ni ahorro.

### Edición y eliminación

Partir de un gasto USD 20:

- Editar a USD 35 cambia saldo en −15 adicional.
- Moverlo a pesos restaura USD 20 y aplica pesos 35.
- Eliminar restaura completamente el efecto vigente.

### Conversor universal

Si A = 2 unidades/USD y B = 10 unidades/USD:

- 4 A = 2 USD = 20 B.
- La ida y vuelta respeta la tolerancia de la escala destino.

## Errores simulables

Cada repositorio fake permite fallar en:

- lectura;
- inserción;
- actualización;
- eliminación;
- segundo o tercer paso de una transacción.

Esto demuestra atomicidad y traducción de errores, no solo caminos felices.

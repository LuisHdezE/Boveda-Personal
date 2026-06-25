# Matriz de trazabilidad

| Requisito | Suites unitarias | Complementarias |
| --- | --- | --- |
| Configuración inicial | ONB, VAL, AUTH, MAP | SQLite, widget, integración |
| Login obligatorio | AUTH, CTRL, ROUTE | widget, integración |
| Contraseña segura | AUTH, LOG | integración/almacenamiento |
| Biometría | BIO, AUTH, CTRL | integración Android |
| Doble moneda | MONEY, ACC, TRF, RATE, DB | SQLite, integración |
| Ingresos y gastos | MOV, ACC, CAT, DB | SQLite, widget, integración |
| Edición/eliminación | MOV, ACC, REP, DB | SQLite transaccional, integración |
| Históricos y filtros | FIL, DATE, DB | SQLite, widget |
| Dashboard | DASH, MONEY, RATE | widget, golden, integración |
| Reportes | REP, DATE, RATE | SQLite, widget, rendimiento |
| Evolución patrimonial | DASH, REP, RATE | widget/golden |
| Simulador | SIM, MONEY, DATE | widget, integración |
| Conversión entre cuentas | TRF, ACC, RATE | SQLite transaccional, integración |
| Calculadora universal | CAL, MONEY | widget, integración |
| Administración de monedas | CAL, VAL, MAP | SQLite, widget |
| Actualización de tasa | RATE, TRF | SQLite, integración |
| Perfil/configuración | SET, VAL | SQLite, widget |
| Funcionamiento offline | casos de uso sin red | integración sin conectividad |
| Privacidad local | LOG, AUTH | inspección APK/dispositivo |
| Material 3 y UI premium | controladores únicamente | widget, golden, visual |
| Accesibilidad | lógica de formato | widget, TalkBack manual |

## Reglas pendientes que impiden cerrar el 100 %

Los siguientes puntos deben resolverse y convertir sus casos `PENDIENTE` en
pruebas ejecutables:

1. Código y escala de la moneda “pesos”.
2. Convención exacta de tasa.
3. Política de redondeo.
4. Permitir o no saldos negativos.
5. Permitir fechas futuras.
6. Política de patrimonio histórico.
7. Fórmula definitiva del simulador.
8. Historial de simulaciones.
9. Restablecimiento y recuperación de contraseña.
10. Edición/eliminación y auditoría.

## Control de cambios

Toda historia nueva debe:

1. indicar su requisito;
2. añadir o reutilizar IDs del catálogo;
3. definir pruebas complementarias si toca UI, SQLite o Android;
4. actualizar esta matriz antes de considerarse terminada.

# Decisiones pendientes

Estas cuestiones surgieron al comparar la especificación con los prototipos.
No bloquean las fundaciones, pero deben resolverse antes de implementar el área
afectada.

## Producto

1. ¿Qué moneda nacional significa “Pesos” (ARS, UYU, MXN, CUP u otra)?
2. ¿La app será estrictamente de un solo usuario por instalación?
3. ¿Se permiten saldos negativos?
4. ¿Los movimientos pueden editarse y eliminarse? En caso afirmativo, ¿se
   requiere auditoría?
5. ¿Se necesitan exportación, importación o respaldo local?
6. ¿El historial de simulaciones es visible o solo una reserva del modelo?

## Cálculos

1. Convención exacta de la tasa: ¿pesos por 1 USD?
2. Reglas de redondeo y decimales por moneda.
3. Tasa utilizada para patrimonio histórico: la vigente en cada fecha o la
   tasa actual.
4. El simulador original pide ingreso y gasto mensual, mientras el prototipo
   usa “ahorro mensual estimado”. Hay que elegir una interfaz y fórmula.

## Seguridad

1. Tiempo y opciones de bloqueo automático.
2. Flujo cuando se olvida la contraseña en una aplicación sin servidor.
3. Si se cifrará toda la base de datos o solo secretos seleccionados.
4. Requisitos Android mínimos para biometría.

## Experiencia

1. Los prototipos alternan USD, ARS y EUR; debe definirse una presentación
   coherente.
2. La especificación enumera una pantalla general de Reportes y Evolución
   patrimonial, pero el paquete no contiene prototipos únicos para ambas.
3. Definir si el selector de moneda principal cambia solo la presentación o
   también los cálculos predeterminados.
4. Confirmar idioma inicial y posibilidad real de localización.

## Registro de decisiones

Cuando se cierre una cuestión, registrar la fecha, decisión y motivo aquí o en
un ADR dentro de `docs/decisions/`. Esto evita que los prototipos antiguos
vuelvan a introducir contradicciones.

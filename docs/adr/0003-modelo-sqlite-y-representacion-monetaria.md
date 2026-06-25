# ADR-0003: Modelo SQLite y representación monetaria

## Estado

Aceptada — 2026-06-25.

## Contexto

Los cálculos financieros no pueden depender de `double` ni de columnas SQLite
`REAL`. Los saldos duplicados pueden perder sincronía al editar o eliminar
movimientos.

## Decisión

- Guardar importes en unidades menores enteras junto con la escala de moneda.
- Guardar tasas como texto decimal canónico.
- Derivar los saldos desde movimientos mediante una vista.
- Representar conversiones con una tabla `transfers` y dos movimientos
  vinculados.
- Aplicar restricciones, claves foráneas y triggers en SQLite además de las
  validaciones de dominio.

## Consecuencias

- Los importes son exactos y auditables.
- Reportes y conversiones deben conocer la escala de moneda.
- Las tasas requieren conversión decimal en Dart antes de calcular.
- Consultar saldos implica agregación, mitigada por índices y el volumen local.

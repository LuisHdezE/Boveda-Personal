# Estrategia de pruebas

Este directorio define las pruebas antes de escribir la aplicación. Es el
contrato de calidad de Bóveda Personal y debe evolucionar junto con los
requisitos.

## Objetivo

- Cubrir el 100 % de las reglas de negocio conocidas.
- Exigir 100 % de cobertura de líneas y funciones en `domain` y `core`.
- Exigir 100 % de cobertura de ramas en cálculos monetarios, autenticación,
  conversiones, movimientos y simulaciones.
- Evitar que una cifra financiera pueda cambiar sin una prueba que explique
  por qué.

El 100 % de cobertura de código no demuestra por sí solo que la aplicación
funcione correctamente. Por eso se combinan:

- **Pruebas unitarias:** entidades, validadores, casos de uso, controladores y
  adaptadores puros.
- **Pruebas de repositorio:** SQLite temporal y migraciones.
- **Pruebas de widgets:** formularios, estados, semántica y navegación.
- **Pruebas de integración:** recorridos completos en Android.

## Documentos

1. [`01-catalogo-unitario.md`](01-catalogo-unitario.md): catálogo completo de
   comportamientos unitarios.
2. [`02-estructura-y-convenciones.md`](02-estructura-y-convenciones.md):
   organización de archivos, nombres y dobles de prueba.
3. [`03-datos-de-prueba.md`](03-datos-de-prueba.md): fixtures y fronteras.
4. [`04-cobertura-y-ci.md`](04-cobertura-y-ci.md): métricas y puertas de CI.
5. [`05-pruebas-complementarias.md`](05-pruebas-complementarias.md): lo que no
   puede validarse honestamente con unit tests.
6. [`06-trazabilidad.md`](06-trazabilidad.md): requisitos y suites que los
   demuestran.

## Estado

Los casos están **diseñados**, no implementados: aún no existe un proyecto
Flutter ni APIs concretas que puedan compilarse o ejecutarse. Durante el
desarrollo se aplicará TDD: crear una prueba, observar el fallo esperado,
implementar lo mínimo y volver a ejecutar.

Los casos marcados `PENDIENTE` dependen de decisiones abiertas del producto.

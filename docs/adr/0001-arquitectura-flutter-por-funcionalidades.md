# ADR-0001: Arquitectura Flutter por funcionalidades

## Estado

Aceptada — 2026-06-25.

## Contexto

La aplicación combina reglas financieras sensibles, persistencia SQLite,
seguridad local y unas 25 pantallas. Debe ser mantenible, comprobable y
completamente offline.

## Decisión

Usar un monolito modular organizado por funcionalidades. Cada feature separa
`domain`, `data` y `presentation` cuando esas capas tengan contenido real.
Riverpod conecta dependencias y estado. La UI no accede directamente a SQLite.

## Consecuencias

- Las reglas financieras pueden probarse sin Flutter ni SQLite.
- Las features mantienen límites claros.
- Hay más archivos que en una estructura por tipo global.
- No se crearán interfaces o capas vacías solo para satisfacer el diagrama.

# Guía del proyecto

Este directorio transforma el material inicial del proyecto en una fuente de
consulta para producto, diseño y desarrollo.

## Orden de lectura

1. [`01-producto.md`](01-producto.md): visión, alcance y reglas de negocio.
2. [`02-experiencia-y-navegacion.md`](02-experiencia-y-navegacion.md): flujos y
   catálogo de pantallas.
3. [`03-arquitectura.md`](03-arquitectura.md): propuesta técnica para Flutter.
4. [`04-modelo-de-datos.md`](04-modelo-de-datos.md): entidades y relaciones.
5. [`05-diseno.md`](05-diseno.md): identidad visual y componentes.
6. [`06-plan-de-desarrollo.md`](06-plan-de-desarrollo.md): fases y criterios de
   terminación.
7. [`07-decisiones-pendientes.md`](07-decisiones-pendientes.md): ambigüedades
   que deben resolverse antes o durante la implementación.
8. [`08-skills-del-proyecto.md`](08-skills-del-proyecto.md): asistentes
   especializados incorporados y reglas para utilizarlos.
9. [`testing/README.md`](testing/README.md): estrategia, catálogo y trazabilidad
   de pruebas para toda la aplicación.
10. [`database/README.md`](database/README.md): esquema SQLite, integridad,
    migraciones y almacenamiento monetario.
11. [`models/README.md`](models/README.md): entidades, objetos de valor y
    modelos SQLite.
12. [`use-cases/README.md`](use-cases/README.md): orquestación funcional,
    contratos y límites externos.

## Fuentes

El paquete de Stitch se conserva íntegro en
[`reference/stitch/stitch_smart_instruction_reader`](reference/stitch/stitch_smart_instruction_reader).
Contiene:

- 46 prototipos HTML.
- 45 capturas de pantalla.
- El sistema de diseño original.
- La especificación inicial del producto.

Los HTML son referencias visuales, no código de producción. Algunos contienen
datos de muestra, monedas inconsistentes o variantes duplicadas. Ante un
conflicto, se debe usar este orden de autoridad:

1. Decisiones explícitas registradas por el equipo.
2. Reglas de negocio de esta guía.
3. Especificación funcional original.
4. Prototipos visuales de Stitch.

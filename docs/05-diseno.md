# Sistema de diseño

La fuente completa está en
[`reference/stitch/stitch_smart_instruction_reader/b_veda_personal_design_system/DESIGN.md`](reference/stitch/stitch_smart_instruction_reader/b_veda_personal_design_system/DESIGN.md).

## Dirección visual

- Material Design 3.
- Apariencia premium, minimalista y oscura.
- Capas tonales y glassmorphism moderado.
- Tipografía Inter.
- Ritmo espacial basado en 8 px.
- Márgenes horizontales de 20 px.
- Tarjetas estándar con radio de 16 px; contenedores destacados de 24 px.

## Colores semánticos

| Uso | Referencia |
| --- | --- |
| Fondo principal | `#091421` |
| Superficie baja | `#121C2A` |
| Superficie | `#16202E` |
| Texto principal | `#D9E3F6` |
| Patrimonio/acción destacada | `#E9C349` |
| Ingreso/éxito | `#4EDEA3` |
| Gasto/error | `#FFB4AB` |
| Información | azul cielo definido en componentes |

El documento de Stitch también menciona variantes de negro, dorado, verde y
rojo distintas. Para Flutter se debe crear una única paleta de tokens y evitar
colores literales dispersos.

## Componentes reutilizables prioritarios

- Tarjeta de saldo/patrimonio.
- Tarjeta de métrica.
- Fila de movimiento.
- Selector de período.
- Campo monetario.
- Selector de moneda.
- Selector de categoría.
- Barra inferior con FAB central.
- Estado vacío y mensaje de error.
- Diálogo de confirmación.
- Gráfico de evolución.
- Distribución por categorías.

## Uso de prototipos

Cada carpeta de referencia incluye `screen.png` y, salvo una excepción,
`code.html`. Se debe usar la captura para intención visual y el HTML para
consultar textos, jerarquía, espaciado e iconografía. No debe trasladarse
Tailwind ni JavaScript directamente a Flutter.

Las carpetas con sufijo `navegable` son iteraciones posteriores y normalmente
tienen prioridad visual sobre su variante inicial. Los datos como EUR, ARS,
fechas, importes y versiones son placeholders, no reglas del producto.

# Plan de desarrollo

## Fase 0 — Fundaciones

- Crear el proyecto Flutter Android.
- Fijar versiones, análisis estático y formato.
- Implementar tema, tokens y navegación base.
- Preparar SQLite, migraciones y manejo de errores.
- Definir el tipo monetario y utilidades de formato.

**Termina cuando:** la app compila, navega entre pantallas vacías y las pruebas
base corren localmente.

## Fase 1 — Alta y autenticación

- Configuración inicial.
- Creación de base y datos iniciales.
- Hash y verificación de contraseña.
- Login, cierre y bloqueo de sesión.

**Termina cuando:** una instalación nueva puede configurarse y volver a entrar
sin red.

## Fase 2 — Núcleo financiero

- Cuentas, categorías y movimientos.
- Alta, detalle, edición y eliminación.
- Históricos y filtros.
- Saldos derivados y transacciones atómicas.

**Termina cuando:** los saldos permanecen correctos ante todas las operaciones
y reinicios.

## Fase 3 — Dashboard y reportes

- Indicadores mensuales.
- Movimientos recientes.
- Agregaciones por período y categoría.
- Gráficos y evolución patrimonial.

**Termina cuando:** cada cifra del dashboard puede rastrearse hasta sus
movimientos y cuenta con pruebas.

## Fase 4 — Monedas y conversiones

- Historial de tasa USD/peso.
- Conversión entre cuentas.
- Administración de monedas.
- Calculadora universal.

**Termina cuando:** las conversiones son reproducibles con la tasa histórica y
la calculadora no modifica saldos.

## Fase 5 — Simulador

- Formulario, motor de proyección y resultados.
- Gráficos, comparativas y advertencia informativa.
- Historial, si se confirma como requisito.

## Fase 6 — Seguridad y acabado

- Biometría y bloqueo automático.
- Accesibilidad, estados vacíos y errores.
- Rendimiento con grandes historiales.
- Pruebas de migración, respaldo/restablecimiento si se aprueba.
- Preparación de compilación Android.

## Definición global de terminado

- Funciona sin conexión.
- Tiene pruebas proporcionales al riesgo.
- No pierde precisión monetaria.
- Maneja errores y estados vacíos.
- Respeta accesibilidad y sistema visual.
- No registra datos sensibles.
- La documentación refleja cualquier decisión nueva.

La estrategia y los umbrales concretos están definidos en
[`testing/README.md`](testing/README.md). Cada fase debe implementar primero los
IDs de prueba correspondientes mediante TDD.

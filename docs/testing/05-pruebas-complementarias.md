# Pruebas complementarias

Estos comportamientos forman parte del 100 % de la aplicación, pero no son
unitarios.

## Repositorio / SQLite

- Creación de todas las tablas, índices, restricciones y claves foráneas.
- Migración desde cada versión soportada.
- Rollback real al fallar una transferencia, onboarding o edición.
- Unicidad de usuario, cuenta y código de moneda.
- Consultas de filtros y agregaciones contra datos reales.
- Orden, paginación y rendimiento con un historial grande.
- Persistencia después de cerrar y volver a abrir la base.

Se ejecutan contra SQLite temporal, no mocks.

## Widgets

- Todos los campos, etiquetas, ayudas y errores.
- Botones habilitados/deshabilitados.
- Loading, vacío, datos y error.
- Escalado de texto y ausencia de overflow.
- Semántica para TalkBack.
- Objetivos táctiles de 48 dp.
- Color no usado como única señal.
- Navegación inferior y FAB.
- Formularios conservan valores tras error.
- Gráficos tienen descripción textual equivalente.

## Integración Android

- Primera apertura→onboarding→dashboard.
- Cierre y login completamente offline.
- Alta, edición y eliminación de ingreso/gasto.
- Conversión y saldos tras reiniciar la aplicación.
- Actualización de tasa sin alterar operaciones históricas.
- Filtros, reportes y simulador.
- Activación, cancelación y desbloqueo biométrico en dispositivo compatible.
- Bloqueo automático al ir a segundo plano.
- Almacenamiento seguro y ausencia de secretos en logs/backups.
- Actualización de versión con migración de base.

## Visual y accesibilidad

- Golden tests para componentes estables en tamaños representativos.
- Tema oscuro y contraste.
- Comparación de pantallas clave con referencias de Stitch.
- TalkBack manual para los recorridos principales.

## Rendimiento

- Arranque con base vacía y con historial grande.
- Scroll de históricos.
- Cálculo de reportes y gráficos.
- Uso de memoria al cambiar repetidamente entre pantallas.

## Seguridad

- Revisión de APK sin contraseñas, claves o datos de muestra.
- Base y preferencias no exponen secretos definidos como protegidos.
- Capturas recientes, backups y logs cumplen la política que se acuerde.
- Intentos biométricos y bloqueo dependen de APIs Android reales.

Un unit test con un mock de biometría prueba nuestra decisión ante una
respuesta; no prueba el sensor, Android Keystore ni el plugin.

# Experiencia y navegación

## Flujo de acceso

```text
Splash
  ├─ Sin configuración → Configuración inicial → Dashboard
  └─ Configurado → Login → Dashboard
                      └─ Biometría, si está habilitada
```

## Navegación principal

La barra inferior mantiene tres destinos:

- **Inicio:** resumen financiero y accesos a funciones.
- **Nuevo:** acción central para registrar un ingreso o gasto.
- **Históricos:** movimientos y filtros.

Desde Inicio se accede a Reportes, Simulador, Conversor y Configuración.

## Mapa funcional de pantallas

### Incorporación y acceso

- Splash.
- Configuración inicial.
- Login.
- Activación y autenticación biométrica.
- Confirmación de seguridad activada.

### Operación diaria

- Dashboard.
- Nuevo movimiento.
- Detalle de movimiento.
- Históricos.
- Filtros avanzados.

### Reportes

- Resumen de reportes.
- Reporte semanal.
- Reporte mensual.
- Reporte trimestral.
- Reporte anual.
- Gastos por categoría.
- Evolución patrimonial.

### Herramientas

- Simulador financiero.
- Resultado de simulación.
- Conversión entre cuentas.
- Calculadora universal.
- Administración de monedas.
- Actualización de tasa USD.

### Configuración

- Configuración.
- Perfil.
- Cambio de contraseña.
- Acerca de.

## Estados que cada pantalla debe contemplar

- Cargando/inicializando.
- Sin datos.
- Con datos.
- Error de validación.
- Error recuperable de almacenamiento.
- Confirmación de operación irreversible.

Los prototipos muestran principalmente el estado “con datos”. Los demás estados
deben diseñarse durante la implementación.

## Accesibilidad y formato

- Objetivos táctiles de al menos 48 × 48 dp.
- Contraste suficiente y significado no dependiente solo del color.
- Importes alineados y con símbolo/código de moneda inequívoco.
- Fechas y números mediante configuración regional.
- Escalado de texto sin cortar cifras ni acciones.
- Etiquetas semánticas para iconos, gráficos y biometría.

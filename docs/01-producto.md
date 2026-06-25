# Producto

## Visión

Bóveda Personal (BP) es una aplicación Android, desarrollada en Flutter, para
registrar y analizar las finanzas de una persona sin depender de conexión,
cuentas remotas ni servicios externos.

## Principios

- **Offline primero:** toda función esencial opera sin red.
- **Privacidad local:** la información financiera permanece en el dispositivo.
- **Claridad financiera:** saldos, movimientos y tendencias deben entenderse
  rápidamente.
- **Doble moneda:** se mantienen cuentas separadas en pesos y USD.
- **Consistencia:** una conversión interna conserva el patrimonio y deja una
  trazabilidad auditable.
- **Datos precisos:** importes y tasas se almacenan con una representación
  decimal segura; nunca con `double` para cálculos monetarios.

## Alcance funcional

### Alta y seguridad

- Configuración inicial del nombre, usuario, contraseña, moneda principal, tasa
  USD y saldos iniciales.
- Inicio de sesión obligatorio.
- Contraseña almacenada mediante hash seguro con salt.
- Preparación para desbloqueo biométrico y bloqueo automático.

### Gestión financiera

- Registrar ingresos y gastos con fecha, categoría, moneda, importe y nota.
- Consultar, filtrar y ver el detalle de movimientos.
- Convertir fondos entre las cuentas de pesos y USD.
- Actualizar la tasa de cambio USD/peso.
- Consultar saldos e indicadores mensuales.

### Análisis

- Ingresos, gastos y ahorro por período.
- Gastos por categoría.
- Comparación de ingresos y gastos.
- Evolución del patrimonio en una moneda común.
- Reportes semanales, mensuales, trimestrales y anuales.

### Simulación

- Proyectar saldo a partir de un saldo inicial, ingresos, gastos, plazo y
  moneda.
- Mostrar evolución periódica, resultado final y comparativas.
- Guardar simulaciones solo si se confirma que aportan valor al historial.

### Conversor universal

- Administrar monedas personalizadas con nombre, código, símbolo, tasa respecto
  a USD y estado.
- Convertir importes usando USD como moneda puente.
- No alterar saldos ni crear movimientos.

## Reglas de negocio esenciales

1. Un ingreso aumenta una cuenta; un gasto la reduce.
2. Una conversión interna crea una operación atómica con importe de origen,
   importe de destino y tasa aplicada.
3. Editar o eliminar un movimiento debe recalcular correctamente los saldos.
4. La tasa usada por una operación histórica no cambia al actualizar la tasa
   vigente.
5. Los saldos iniciales deben quedar auditables, como movimientos de apertura o
   mediante un registro equivalente.
6. Las métricas de patrimonio convierten importes con una tasa definida y
   muestran la fecha o contexto de esa tasa.
7. Los filtros combinan período, categoría, moneda y tipo.
8. Una moneda inactiva no se ofrece para nuevas conversiones, pero conserva su
   historial.

## Fuera del alcance inicial

- Backend, sincronización en la nube y versión web.
- Integración bancaria automática.
- Cotizaciones en línea obligatorias.
- Múltiples usuarios o finanzas compartidas.
- Asesoramiento financiero o promesas de rendimiento.

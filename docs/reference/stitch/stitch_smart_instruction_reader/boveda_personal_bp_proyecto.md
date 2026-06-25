# Bóveda Personal (BP)

## Descripción

Bóveda Personal (BP) es una aplicación móvil Android desarrollada en
Flutter para la gestión personal de finanzas. Funciona completamente
offline utilizando SQLite y permite registrar ingresos, gastos, ahorros,
simulaciones financieras y análisis mediante gráficos.

## Objetivos

-   100% offline.
-   Seguridad mediante usuario y contraseña.
-   Base de datos SQLite creada automáticamente en la primera ejecución.
-   Soporte para doble moneda (Pesos y USD).
-   Conversor universal de monedas.
-   Dashboard moderno y atractivo.

# Tecnología

-   Flutter (última versión estable)
-   Dart
-   SQLite (sqflite)
-   flutter_secure_storage
-   fl_chart
-   Provider o Riverpod

# Requerimientos funcionales

## Primer inicio

-   Crear la base de datos.
-   Solicitar:
    -   Nombre del usuario.
    -   Usuario.
    -   Contraseña.
    -   Moneda principal.
    -   Valor inicial del dólar.
    -   Saldo inicial en pesos.
    -   Saldo inicial en dólares.

## Seguridad

-   Login obligatorio.
-   Contraseña cifrada.
-   Preparado para biometría.

## Dashboard

Mostrar: - Saldo en pesos. - Saldo en dólares. - Total convertido a
USD. - Total convertido a pesos. - Ingresos del mes. - Gastos del mes. -
Ahorro del mes. - Últimos movimientos. - Gráfico de evolución.

## Movimientos

Tipos: - Ingreso - Gasto - Conversión entre cuentas

Campos: - Fecha - Tipo - Categoría - Moneda - Importe - Nota

## Históricos

Filtros: - Día - Semana - Mes - Trimestre - Año - Categoría - Moneda -
Tipo

## Reportes

Gráficos: - Ahorro semanal - Ahorro mensual - Trimestral - Anual -
Gastos por categoría - Ingresos vs gastos - Evolución del patrimonio

## Simulador

Entradas: - Saldo inicial - Ingreso mensual - Gasto mensual - Tiempo -
Moneda

Resultados: - Saldo proyectado - Evolución mensual - Gráficos -
Comparativas

## Conversor

### A. Conversión entre cuentas

-   Solo Pesos/USD.
-   Actualiza saldos.
-   Registra movimiento interno.

### B. Calculadora Universal

No modifica saldos.

Permite agregar monedas ilimitadas.

Cada moneda almacena: - Nombre - Código - Símbolo - Valor respecto a 1
USD - Activa/Inactiva

Todas las conversiones utilizan USD como moneda puente.

# Casos de uso

1.  Configurar aplicación.
2.  Iniciar sesión.
3.  Registrar ingreso.
4.  Registrar gasto.
5.  Convertir dinero entre cuentas.
6.  Consultar histórico.
7.  Consultar reportes.
8.  Ejecutar simulación.
9.  Administrar monedas de la calculadora.
10. Actualizar tasa USD.
11. Realizar conversión sin afectar saldos.
12. Modificar configuración.

# Historias de usuario

-   Como usuario quiero registrar ingresos para conocer mi patrimonio.
-   Como usuario quiero registrar gastos para controlar mis finanzas.
-   Como usuario quiero visualizar gráficos para entender mi
    comportamiento financiero.
-   Como usuario quiero proyectar mis ahorros futuros.
-   Como usuario quiero convertir dinero entre mis cuentas.
-   Como usuario quiero realizar conversiones rápidas sin alterar mis
    saldos.
-   Como usuario quiero administrar monedas personalizadas.
-   Como usuario quiero trabajar completamente offline.

# Lista detallada de vistas

1.  Splash.
2.  Configuración inicial.
3.  Login.
4.  Dashboard.
5.  Nuevo movimiento.
6.  Detalle de movimiento.
7.  Históricos.
8.  Filtros del histórico.
9.  Reportes.
10. Reporte semanal.
11. Reporte mensual.
12. Reporte trimestral.
13. Reporte anual.
14. Gastos por categoría.
15. Evolución patrimonial.
16. Simulador.
17. Resultado de simulación.
18. Conversión entre cuentas.
19. Calculadora universal.
20. Administración de monedas.
21. Actualizar tasa USD.
22. Configuración.
23. Perfil.
24. Cambio de contraseña.
25. Acerca de.

# Modelo de datos

users settings movements categories exchange_rates calculator_currencies
simulation_history

# Navegación

Bottom Navigation: - Inicio - (+) Nuevo movimiento - Históricos

Desde Inicio: - Reportes - Simulador - Conversor - Configuración

# Lineamientos UI

-   Material Design 3
-   Tema oscuro elegante
-   Verde: ingresos
-   Rojo: gastos
-   Azul: información
-   Dorado: patrimonio
-   Tarjetas con bordes redondeados
-   FAB central prominente
-   Animaciones suaves

# Instrucciones para Stitch

Diseñar exclusivamente una aplicación móvil Android.

Mantener una identidad visual premium y minimalista.

Generar todas las vistas listadas anteriormente.

Mantener consistencia entre pantallas.

No modificar navegación.

Utilizar Material Design 3.

Usar tarjetas, gráficos y FAB central.

Priorizar la experiencia móvil.

No generar backend.

No utilizar datos ficticios permanentes; emplear placeholders.

Preparar componentes reutilizables para listas, gráficos, formularios y
tarjetas.

Toda la aplicación debe ser completamente offline.

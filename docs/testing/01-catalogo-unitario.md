# Catálogo de pruebas unitarias

Cada identificador representa un comportamiento independiente. Las variantes
indicadas como matrices se implementan con pruebas parametrizadas.

## CORE-MONEY — Dinero y precisión

| ID | Comportamiento esperado |
| --- | --- |
| MONEY-001 | Crea un importe válido desde unidades menores. |
| MONEY-002 | Rechaza una cantidad menor que cero cuando el contexto exige importe positivo. |
| MONEY-003 | Conserva cero sin cambiar escala ni moneda. |
| MONEY-004 | Suma importes de la misma moneda exactamente. |
| MONEY-005 | Resta importes de la misma moneda exactamente. |
| MONEY-006 | Rechaza suma o resta entre monedas diferentes. |
| MONEY-007 | Compara correctamente menor, igual y mayor. |
| MONEY-008 | Multiplica por una tasa decimal sin usar `double`. |
| MONEY-009 | Divide por una tasa decimal válida. |
| MONEY-010 | Rechaza división por cero o tasa negativa. |
| MONEY-011 | Redondea mitad arriba según la escala configurada. |
| MONEY-012 | Redondea hacia abajo cuando el siguiente dígito no alcanza la mitad. |
| MONEY-013 | Maneja valores máximos soportados sin desbordamiento silencioso. |
| MONEY-014 | Serializa y restaura sin pérdida de precisión. |
| MONEY-015 | Mantiene igualdad y `hashCode` para valor, moneda y escala iguales. |
| MONEY-016 | Trata valores con moneda o escala distinta como diferentes. |
| MONEY-017 | Normaliza códigos de moneda a mayúsculas. |
| MONEY-018 | Rechaza códigos vacíos o que no cumplen el formato acordado. |
| MONEY-019 | Formatea cero, positivo y negativo según locale y moneda. |
| MONEY-020 | Analiza entradas con separadores regionales válidos. |
| MONEY-021 | Rechaza texto, múltiples separadores y precisión excesiva. |
| MONEY-022 | No introduce error acumulado al sumar una serie extensa de centavos. |

Matriz mínima: `0`, `1`, `0.01`, valor con todos los decimales permitidos,
valor máximo, separadores `.`/`,` y monedas de 0, 2 y 3 decimales.

## CORE-DATE — Fechas y períodos

| ID | Comportamiento esperado |
| --- | --- |
| DATE-001 | Convierte fecha local a UTC y restaura el instante correcto. |
| DATE-002 | Calcula inicio y fin de día local. |
| DATE-003 | Calcula semana conforme a la convención elegida. |
| DATE-004 | Calcula mes incluyendo febrero y años bisiestos. |
| DATE-005 | Calcula trimestre para los doce meses. |
| DATE-006 | Calcula año completo. |
| DATE-007 | Incluye el límite inicial y excluye el límite final. |
| DATE-008 | Navega al período anterior y siguiente sin saltos. |
| DATE-009 | Agrupa movimientos cercanos a medianoche por fecha local. |
| DATE-010 | Produce etiquetas localizadas sin alterar el valor almacenado. |
| DATE-011 | Maneja cambio de año entre diciembre y enero. |
| DATE-012 | Usa un `Clock` inyectable en lugar del reloj real. |

## CORE-VALIDATION — Validadores comunes

| ID | Comportamiento esperado |
| --- | --- |
| VAL-001 | Recorta espacios externos del nombre. |
| VAL-002 | Rechaza nombre vacío y acepta límites válidos. |
| VAL-003 | Normaliza usuario sin modificar caracteres significativos. |
| VAL-004 | Rechaza usuario vacío, demasiado corto o demasiado largo. |
| VAL-005 | Valida contraseña según la política decidida. |
| VAL-006 | Rechaza confirmación de contraseña diferente. |
| VAL-007 | Rechaza importe vacío, cero cuando no se permite y negativo. |
| VAL-008 | Rechaza tasa vacía, cero, negativa o no numérica. |
| VAL-009 | Valida nota opcional y su longitud máxima. |
| VAL-010 | Valida código, símbolo y nombre de moneda. |
| VAL-011 | Valida que una fecha no incumpla la política de fechas futuras. |
| VAL-012 | Devuelve errores de dominio estables, no textos de interfaz. |

## ONBOARDING — Configuración inicial

| ID | Comportamiento esperado |
| --- | --- |
| ONB-001 | Detecta instalación sin configurar. |
| ONB-002 | Detecta configuración completa. |
| ONB-003 | No considera completa una configuración parcial. |
| ONB-004 | Crea usuario con hash y salt, nunca contraseña en claro. |
| ONB-005 | Crea configuración con moneda y locale seleccionados. |
| ONB-006 | Crea exactamente una cuenta para USD y otra para pesos. |
| ONB-007 | Registra la tasa inicial con instante efectivo. |
| ONB-008 | Registra saldos iniciales como movimientos de apertura auditables. |
| ONB-009 | Omite movimiento de apertura cuando el saldo es cero. |
| ONB-010 | Crea categorías iniciales sin duplicarlas. |
| ONB-011 | Marca onboarding completo solo tras finalizar toda la transacción. |
| ONB-012 | Revierte todos los cambios si falla cualquier paso. |
| ONB-013 | Rechaza usuario duplicado. |
| ONB-014 | Rechaza cuentas con la misma moneda. |
| ONB-015 | Reintentar después de fallo produce un único conjunto de datos. |
| ONB-016 | Devuelve un resultado de éxito sin exponer secretos. |

## AUTH — Contraseña, sesión y bloqueo

| ID | Comportamiento esperado |
| --- | --- |
| AUTH-001 | Genera un salt distinto para contraseñas iguales. |
| AUTH-002 | El hash no contiene ni equivale a la contraseña. |
| AUTH-003 | Verifica contraseña correcta. |
| AUTH-004 | Rechaza contraseña incorrecta. |
| AUTH-005 | La comparación de credenciales evita salida temprana observable. |
| AUTH-006 | Login exitoso crea sesión autenticada. |
| AUTH-007 | Login fallido mantiene sesión cerrada. |
| AUTH-008 | Usuario inexistente devuelve error indistinguible de contraseña inválida. |
| AUTH-009 | Cerrar sesión elimina el estado autenticado. |
| AUTH-010 | Cambiar contraseña exige la contraseña actual. |
| AUTH-011 | Cambio válido genera salt y hash nuevos. |
| AUTH-012 | Tras el cambio, la contraseña anterior deja de funcionar. |
| AUTH-013 | Un fallo al persistir conserva la contraseña anterior. |
| AUTH-014 | Calcula bloqueo automático desde la última actividad. |
| AUTH-015 | No bloquea antes del umbral configurado. |
| AUTH-016 | Bloquea exactamente al alcanzar el umbral. |
| AUTH-017 | Actividad válida reinicia el temporizador. |
| AUTH-018 | Volver desde segundo plano aplica la política de bloqueo. |
| AUTH-019 | La opción “inmediato” bloquea al perder foco. |
| AUTH-020 | Una duración desactivada no bloquea automáticamente. |

## BIOMETRICS — Orquestación biométrica

Las respuestas del plugin se simulan detrás de un puerto; la compatibilidad real
se prueba en integración.

| ID | Comportamiento esperado |
| --- | --- |
| BIO-001 | Solo ofrece activación si el dispositivo reporta soporte. |
| BIO-002 | Distingue no disponible, no configurada y bloqueo temporal. |
| BIO-003 | Activa biometría tras autenticación exitosa. |
| BIO-004 | No la activa si el usuario cancela o falla. |
| BIO-005 | Desactivarla elimina el secreto biométrico local. |
| BIO-006 | Desbloqueo exitoso abre sesión. |
| BIO-007 | Fallo biométrico conserva sesión cerrada y permite contraseña. |
| BIO-008 | Error del plugin se convierte en error de dominio recuperable. |
| BIO-009 | Biometría no recupera ni revela la contraseña. |
| BIO-010 | Cambio de contraseña invalida o renueva el secreto biométrico. |

## ACCOUNTS — Cuentas y saldos

| ID | Comportamiento esperado |
| --- | --- |
| ACC-001 | Crea cuenta con código normalizado. |
| ACC-002 | Rechaza moneda duplicada. |
| ACC-003 | Deriva saldo de movimientos, no de una copia independiente. |
| ACC-004 | Apertura e ingreso suman saldo. |
| ACC-005 | Gasto y transferencia de salida restan saldo. |
| ACC-006 | Transferencia de entrada suma saldo. |
| ACC-007 | Ajuste aplica el signo definido por su subtipo. |
| ACC-008 | Movimientos de otra cuenta no afectan el saldo. |
| ACC-009 | Saldo vacío equivale a cero en la moneda de la cuenta. |
| ACC-010 | Desactivar cuenta conserva saldo e historial. |
| ACC-011 | Cuenta inactiva no admite nuevos movimientos ordinarios. |
| ACC-012 | Política de saldo negativo se aplica de forma consistente (`PENDIENTE`). |

## CATEGORIES — Categorías

| ID | Comportamiento esperado |
| --- | --- |
| CAT-001 | Crea categoría válida de ingreso, gasto o ambos. |
| CAT-002 | Rechaza nombre vacío o duplicado según normalización. |
| CAT-003 | Categoría de gasto no puede usarse en ingreso y viceversa. |
| CAT-004 | Categoría “ambos” sirve para los dos tipos. |
| CAT-005 | Categoría inactiva no aparece para nuevos movimientos. |
| CAT-006 | Categoría inactiva conserva movimientos históricos. |
| CAT-007 | Categoría de sistema no se elimina físicamente. |
| CAT-008 | Actualizar nombre/icono/color no altera su identidad. |

## MOVEMENTS — Ingresos, gastos y ajustes

| ID | Comportamiento esperado |
| --- | --- |
| MOV-001 | Registra ingreso válido. |
| MOV-002 | Registra gasto válido. |
| MOV-003 | Rechaza importe cero o negativo. |
| MOV-004 | Rechaza cuenta inexistente o inactiva. |
| MOV-005 | Rechaza categoría incompatible o inactiva. |
| MOV-006 | Normaliza nota vacía a `null`. |
| MOV-007 | Conserva fecha, importe, moneda y nota exactos. |
| MOV-008 | Un ingreso incrementa el saldo por el importe exacto. |
| MOV-009 | Un gasto reduce el saldo por el importe exacto. |
| MOV-010 | Un fallo de persistencia no deja efectos parciales. |
| MOV-011 | Editar importe revierte el anterior y aplica el nuevo. |
| MOV-012 | Editar tipo revierte correctamente el signo anterior. |
| MOV-013 | Editar cuenta mueve el efecto completo entre cuentas. |
| MOV-014 | Editar fecha cambia el período de reportes. |
| MOV-015 | Editar categoría cambia su agregación. |
| MOV-016 | Eliminar ingreso resta su efecto. |
| MOV-017 | Eliminar gasto devuelve su efecto. |
| MOV-018 | No permite editar un lado de una transferencia como movimiento ordinario. |
| MOV-019 | No permite eliminar solo un lado de una transferencia. |
| MOV-020 | Operación sobre ID inexistente devuelve `notFound`. |
| MOV-021 | Dos operaciones con IDs diferentes no se sobrescriben. |
| MOV-022 | Ordena por fecha y usa ID estable como desempate. |
| MOV-023 | La paginación no repite ni omite elementos. |
| MOV-024 | Política de fechas futuras se respeta (`PENDIENTE`). |

## FILTERS — Históricos

Probar cada filtro aislado y todas las combinaciones por pares; añadir una
combinación que incluya todos.

| ID | Comportamiento esperado |
| --- | --- |
| FIL-001 | Sin filtros devuelve todos los movimientos visibles. |
| FIL-002 | Filtra por día. |
| FIL-003 | Filtra por semana. |
| FIL-004 | Filtra por mes. |
| FIL-005 | Filtra por trimestre. |
| FIL-006 | Filtra por año. |
| FIL-007 | Filtra por rango personalizado. |
| FIL-008 | Filtra por categoría. |
| FIL-009 | Filtra por cuenta/moneda. |
| FIL-010 | Filtra por ingreso, gasto y conversión. |
| FIL-011 | Combina período + categoría. |
| FIL-012 | Combina período + moneda. |
| FIL-013 | Combina período + tipo. |
| FIL-014 | Combina categoría + moneda + tipo. |
| FIL-015 | Combina todos los filtros con semántica AND. |
| FIL-016 | Devuelve vacío cuando no hay coincidencias. |
| FIL-017 | Limpiar filtros restaura la consulta base. |
| FIL-018 | Límites temporales no duplican movimientos. |

## TRANSFERS — Conversión entre cuentas

Convención provisional: `rate = unidades de moneda destino por una unidad de
origen`. Debe sustituirse por la decisión final.

| ID | Comportamiento esperado |
| --- | --- |
| TRF-001 | Rechaza cuentas iguales. |
| TRF-002 | Rechaza cuenta inexistente o inactiva. |
| TRF-003 | Rechaza importe o tasa no positivos. |
| TRF-004 | Calcula importe destino con precisión y redondeo correctos. |
| TRF-005 | Crea un registro lógico de transferencia. |
| TRF-006 | Crea exactamente un `transfer_out` y un `transfer_in`. |
| TRF-007 | Vincula ambos movimientos al mismo `transfer_id`. |
| TRF-008 | Reduce origen y aumenta destino de forma exacta. |
| TRF-009 | Conserva la tasa histórica aplicada. |
| TRF-010 | Actualizar la tasa vigente no cambia la transferencia existente. |
| TRF-011 | Falla atómicamente si no se guarda cualquiera de los tres registros. |
| TRF-012 | Elimina ambos movimientos y la transferencia atómicamente. |
| TRF-013 | Editar recalcula ambos lados en una sola transacción. |
| TRF-014 | Política de fondos insuficientes se aplica (`PENDIENTE`). |
| TRF-015 | Convertir USD→peso y peso→USD respeta la convención de tasa final. |
| TRF-016 | El patrimonio convertido permanece igual salvo redondeo permitido. |

## RATES — Tasas de cambio

| ID | Comportamiento esperado |
| --- | --- |
| RATE-001 | Registra tasa positiva con par e instante. |
| RATE-002 | Rechaza tasa cero o negativa. |
| RATE-003 | Rechaza par con monedas iguales. |
| RATE-004 | Obtiene la última tasa efectiva anterior o igual al instante. |
| RATE-005 | No utiliza una tasa futura. |
| RATE-006 | Desempata tasas con instante igual de forma determinista. |
| RATE-007 | Calcula tasa inversa con precisión controlada. |
| RATE-008 | Devuelve ausencia explícita si no hay tasa. |
| RATE-009 | Actualizar tasa agrega historial, no sobrescribe el pasado. |
| RATE-010 | Normaliza ambos códigos de moneda. |

## DASHBOARD — Resumen financiero

| ID | Comportamiento esperado |
| --- | --- |
| DASH-001 | Muestra cero para cuentas sin movimientos. |
| DASH-002 | Calcula saldo de cada cuenta. |
| DASH-003 | Convierte patrimonio total a USD. |
| DASH-004 | Convierte patrimonio total a pesos. |
| DASH-005 | Usa la tasa determinada por la política vigente (`PENDIENTE`). |
| DASH-006 | Suma ingresos del mes local actual. |
| DASH-007 | Suma gastos del mes local actual. |
| DASH-008 | Calcula ahorro como ingresos menos gastos. |
| DASH-009 | No cuenta transferencias internas como ingreso o gasto. |
| DASH-010 | Selecciona últimos movimientos con orden estable. |
| DASH-011 | Limita la lista al tamaño solicitado. |
| DASH-012 | Genera serie patrimonial cronológica. |
| DASH-013 | Rellena o no períodos vacíos según contrato acordado. |
| DASH-014 | Error de tasa ausente produce estado definido, no cifra falsa. |
| DASH-015 | No mezcla monedas sin conversión explícita. |

## REPORTS — Agregaciones y gráficos

La misma matriz se ejecuta para semana, mes, trimestre y año.

| ID | Comportamiento esperado |
| --- | --- |
| REP-001 | Totaliza ingresos del período. |
| REP-002 | Totaliza gastos del período. |
| REP-003 | Calcula ahorro y tasa de ahorro. |
| REP-004 | Evita división por cero en tasa de ahorro. |
| REP-005 | Excluye transferencias internas de flujo. |
| REP-006 | Agrupa gastos por categoría. |
| REP-007 | Incluye categoría desconocida para históricos huérfanos permitidos. |
| REP-008 | Ordena categorías por importe y desempata de forma estable. |
| REP-009 | Calcula porcentaje de categoría y suma aproximadamente 100 %. |
| REP-010 | Redondeo de porcentajes no altera los totales monetarios. |
| REP-011 | Compara ingresos contra gastos por subperíodo. |
| REP-012 | Genera puntos cronológicos para evolución patrimonial. |
| REP-013 | Convierte cada punto con la política histórica decidida (`PENDIENTE`). |
| REP-014 | Un período vacío produce serie vacía o ceros según contrato. |
| REP-015 | Un único punto produce una serie válida. |
| REP-016 | Movimientos en los límites pertenecen a un solo período. |
| REP-017 | Reporte filtrado por moneda no mezcla otras cuentas. |
| REP-018 | Los totales del reporte coinciden con la suma de sus grupos. |

## CALCULATOR — Monedas y calculadora universal

| ID | Comportamiento esperado |
| --- | --- |
| CAL-001 | Crea moneda con nombre, código, símbolo y unidades por USD válidos. |
| CAL-002 | Rechaza código duplicado sin distinguir mayúsculas. |
| CAL-003 | Rechaza tasa cero o negativa. |
| CAL-004 | Actualiza datos sin cambiar identidad. |
| CAL-005 | Desactiva moneda sin borrar historial. |
| CAL-006 | Moneda inactiva no aparece para conversiones nuevas. |
| CAL-007 | Convierte USD→moneda multiplicando por unidades por USD. |
| CAL-008 | Convierte moneda→USD dividiendo por unidades por USD. |
| CAL-009 | Convierte moneda A→B usando USD como puente. |
| CAL-010 | Convertir una moneda a sí misma devuelve el importe exacto. |
| CAL-011 | Aplica escala y redondeo de moneda destino. |
| CAL-012 | Rechaza moneda desconocida o inactiva. |
| CAL-013 | No crea movimientos ni modifica saldos. |
| CAL-014 | Conversión ida y vuelta queda dentro de tolerancia de redondeo. |
| CAL-015 | Maneja tasas muy grandes y pequeñas sin desbordar ni perder precisión. |

## SIMULATOR — Proyecciones

Fórmula provisional mensual:
`saldo[n] = saldo[n-1] + ingresoMensual - gastoMensual`. Si se decide usar
“ahorro mensual”, se reemplazan los casos de ingreso/gasto por aporte neto.

| ID | Comportamiento esperado |
| --- | --- |
| SIM-001 | Rechaza duración cero o negativa. |
| SIM-002 | Rechaza importes inválidos según la política final. |
| SIM-003 | Un mes aplica exactamente un ciclo. |
| SIM-004 | N meses genera N puntos y un saldo final. |
| SIM-005 | Ahorro neto positivo incrementa saldo linealmente. |
| SIM-006 | Ahorro neto cero mantiene saldo. |
| SIM-007 | Ahorro neto negativo reduce saldo. |
| SIM-008 | Saldo inicial cero funciona. |
| SIM-009 | Conversión de años a meses es exacta. |
| SIM-010 | Fechas proyectadas avanzan mes a mes correctamente. |
| SIM-011 | No usa fecha o aleatoriedad real; recibe reloj. |
| SIM-012 | Mantiene moneda en todos los puntos. |
| SIM-013 | No mezcla monedas. |
| SIM-014 | Valores grandes no desbordan. |
| SIM-015 | El resultado no modifica cuentas ni movimientos. |
| SIM-016 | Guardar historial persiste entrada y resultado exactos (`PENDIENTE`). |
| SIM-017 | No guardar historial no produce escritura (`PENDIENTE`). |

## SETTINGS — Preferencias y perfil

| ID | Comportamiento esperado |
| --- | --- |
| SET-001 | Obtiene configuración por defecto solo antes del onboarding. |
| SET-002 | Actualiza nombre visible sin cambiar usuario. |
| SET-003 | Rechaza usuario duplicado al editar perfil. |
| SET-004 | Cambia moneda principal a una moneda soportada. |
| SET-005 | Rechaza moneda principal inexistente o inactiva. |
| SET-006 | Cambiar locale afecta formato, no datos guardados. |
| SET-007 | Actualiza duración de bloqueo válida. |
| SET-008 | Rechaza duración fuera de opciones permitidas. |
| SET-009 | Persiste preferencia biométrica solo tras completar activación. |
| SET-010 | Un fallo de escritura conserva la configuración previa. |
| SET-011 | Restablecimiento borra datos según la política final (`PENDIENTE`). |
| SET-012 | La información “Acerca de” se obtiene de metadatos, no de literal duplicado. |

## CONTROLLERS — Estado de presentación

Se prueban controladores Riverpod sin renderizar widgets.

| ID | Comportamiento esperado |
| --- | --- |
| CTRL-001 | Estado inicial es coherente con cada pantalla. |
| CTRL-002 | Una carga emite `loading` y luego `data`. |
| CTRL-003 | Error de repositorio emite error recuperable. |
| CTRL-004 | Reintentar vuelve a ejecutar la operación. |
| CTRL-005 | Envío válido evita doble pulsación concurrente. |
| CTRL-006 | Envío inválido no llama al caso de uso. |
| CTRL-007 | Éxito limpia o conserva formulario según contrato. |
| CTRL-008 | Error mantiene entradas para corrección. |
| CTRL-009 | Cambio de filtro cancela o ignora resultado obsoleto. |
| CTRL-010 | `dispose` evita emitir estado posterior. |
| CTRL-011 | Refresco no borra datos válidos mientras carga. |
| CTRL-012 | Estado vacío se diferencia de error. |

Aplicar CTRL-001..012 a onboarding, login, dashboard, movimiento, históricos,
reportes, simulador, conversor, monedas y configuración cuando corresponda.

## MAPPERS — Persistencia y errores

| ID | Comportamiento esperado |
| --- | --- |
| MAP-001 | Cada entidad se convierte a fila y vuelve sin pérdida. |
| MAP-002 | `null` opcional se conserva. |
| MAP-003 | Enum válido se serializa con valor estable. |
| MAP-004 | Enum desconocido produce error controlado. |
| MAP-005 | Fecha UTC conserva precisión acordada. |
| MAP-006 | Dinero decimal conserva valor y escala. |
| MAP-007 | Booleanos SQLite 0/1 se mapean correctamente. |
| MAP-008 | Claves foráneas opcionales se conservan. |
| MAP-009 | Violación de unicidad se traduce a `conflict`. |
| MAP-010 | Clave foránea inválida se traduce a error de integridad. |
| MAP-011 | Base bloqueada o no disponible se traduce a error recuperable. |
| MAP-012 | Error desconocido no expone detalles sensibles. |

Ejecutar MAP-001..008 para `User`, `Settings`, `Account`, `Category`,
`Movement`, `Transfer`, `ExchangeRate`, `CalculatorCurrency` y
`SimulationHistory`.

## MODEL — Entidades y objetos de valor

| ID | Comportamiento esperado |
| --- | --- |
| MODEL-001 | Entidades con los mismos datos son iguales y comparten hash. |
| MODEL-002 | `copyWith` modifica únicamente los campos solicitados. |
| MODEL-003 | Modelos financieros conservan tipos, monedas y signo. |
| MODEL-004 | Configuración, tasas, monedas y simulaciones conservan sus valores. |
| MODEL-005 | Rechaza rangos temporales vacíos o invertidos. |
| MODEL-006 | Paginación rechaza límites y offsets inválidos. |
| MODEL-007 | Una página determina correctamente si tiene continuación. |
| MODEL-008 | Una cotización exige resultado en la moneda solicitada. |
| MODEL-009 | Dashboard no mezcla monedas en sus métricas. |
| MODEL-010 | Las series de reportes deben estar ordenadas cronológicamente. |
| MODEL-011 | Credenciales y cambios de contraseña no exponen secretos. |

Los round-trips entidad→fila→entidad se cubren además mediante MAP-001.

## DB — SQLite, migraciones y DAOs

Estas pruebas usan SQLite real en memoria mediante `sqflite_common_ffi`.

| ID | Comportamiento esperado |
| --- | --- |
| DB-001 | Crea todas las tablas, índices, vistas y triggers. |
| DB-002 | Activa claves foráneas en cada conexión. |
| DB-003 | Registra la versión actual del esquema. |
| DB-004 | Inserta exactamente las categorías del sistema. |
| DB-005 | Abrir nuevamente no duplica seeds. |
| DB-006 | La vista de saldos aplica signos por tipo. |
| DB-007 | Una transacción fallida revierte todos sus cambios. |
| DB-008 | Rechaza códigos de moneda no normalizados. |
| DB-009 | Rechaza importes no positivos. |
| DB-010 | Exige transferencia para movimientos internos. |
| DB-011 | Protege categorías con historial. |
| DB-012 | Migra una base nueva desde cero. |
| DB-013 | Rechaza downgrade implícito. |
| DB-014 | Rechaza versiones objetivo desconocidas. |
| DB-015 | Rechaza categoría incompatible con el movimiento. |
| DB-016 | Rechaza movimientos nuevos en cuentas inactivas. |
| DB-017 | Combina filtros de movimientos con semántica AND. |
| DB-018 | Pagina movimientos con orden estable. |
| DB-019 | Crea transferencia y movimientos atómicamente. |
| DB-020 | Revierte transferencia si falla cualquiera de sus movimientos. |
| DB-021 | Eliminar transferencia elimina ambos movimientos. |
| DB-022 | Obtiene la última tasa efectiva aplicable. |
| DB-023 | Devuelve ausencia si ninguna tasa es aplicable. |
| DB-024 | Activa borrado seguro de páginas SQLite. |
| DB-025 | Impide desincronizar transferencias mediante update parcial. |

## LOGGING — Protección de información

| ID | Comportamiento esperado |
| --- | --- |
| LOG-001 | Redacta contraseña, hash y salt. |
| LOG-002 | Redacta notas de movimientos. |
| LOG-003 | Redacta importes financieros según política de logs. |
| LOG-004 | No registra secretos biométricos. |
| LOG-005 | Conserva tipo de error y correlación no sensible. |
| LOG-006 | `toString` de entidades sensibles no expone campos privados. |

## APP-ROUTING — Decisiones puras de arranque

| ID | Comportamiento esperado |
| --- | --- |
| ROUTE-001 | Sin onboarding dirige a configuración inicial. |
| ROUTE-002 | Configurado y sin sesión dirige a login. |
| ROUTE-003 | Configurado y autenticado dirige a dashboard. |
| ROUTE-004 | Sesión bloqueada dirige a desbloqueo. |
| ROUTE-005 | Ruta protegida redirige si no hay sesión. |
| ROUTE-006 | Ruta pública no entra en bucle de redirección. |
| ROUTE-007 | Restaurar ruta tras login solo permite destinos válidos. |
| ROUTE-008 | Estado inconsistente usa una ruta segura de recuperación. |

## USECASE — Orquestación de aplicación

| ID | Comportamiento esperado |
| --- | --- |
| USECASE-001 | Login valida credenciales y crea sesión sin revelar si el usuario existe. |
| USECASE-002 | Configuración inicial persiste todos sus elementos atómicamente. |
| USECASE-003 | Crear movimiento valida cuenta, categoría, moneda e importe. |
| USECASE-004 | Transferencia crea o reemplaza operación y dos movimientos juntos. |
| USECASE-005 | Dashboard convierte saldos antes de totalizarlos. |
| USECASE-006 | Reportes excluyen transferencias y agrupan gastos por categoría. |
| USECASE-007 | Conversor usa USD como puente sin modificar saldos. |
| USECASE-008 | Simulador genera un punto por mes. |
| USECASE-009 | Cambio de contraseña verifica la actual y genera nuevo hash/salt. |
| USECASE-010 | Biometría solo se habilita después de autenticación local correcta. |

# Cobertura y puertas de CI

## Objetivos

| Área | Líneas | Funciones | Ramas |
| --- | ---: | ---: | ---: |
| `lib/core/**` | 100 % | 100 % | 100 % |
| `lib/**/domain/**` | 100 % | 100 % | 100 % |
| casos de uso financieros y seguridad | 100 % | 100 % | 100 % |
| `lib/**/data/**` no generado | 100 % | 100 % | ≥ 95 % |
| controladores/providers | 100 % | 100 % | ≥ 95 % |
| proyecto no generado completo | ≥ 95 % | ≥ 95 % | ≥ 90 % |

Flutter genera cobertura LCOV de líneas; la medición de ramas/funciones puede
requerir tooling adicional o auditoría de casos. La exigencia funcional se
controla además mediante IDs de trazabilidad.

## Puertas

Una contribución falla si:

1. `flutter analyze` produce errores o advertencias configuradas como error.
2. Algún test falla.
3. Baja un umbral de cobertura.
4. Añade una regla de negocio sin ID de prueba.
5. Modifica dinero, tasas, autenticación o migraciones sin prueba de regresión.
6. Introduce `DateTime.now()`, IDs aleatorios o plugins directamente en dominio.
7. Deja tests omitidos sin una incidencia y fecha de resolución.

## Comandos previstos

```text
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test --coverage
```

La comprobación concreta de LCOV se añadirá al crear el proyecto Flutter y
fijar la herramienta compatible.

## Mutation testing

Una cifra alta puede esconder asserts débiles. Para las áreas críticas se debe
usar mutation testing cuando el ecosistema fijado lo permita:

- invertir signos de ingreso/gasto;
- cambiar `<` por `<=` en límites;
- quitar redondeo;
- ignorar moneda;
- omitir un lado de transferencia;
- usar tasa actual en vez de histórica;
- aceptar contraseña incorrecta.

Meta: ≥ 90 % de mutantes eliminados en dominio crítico y 100 % para mutantes
predefinidos de dinero y transferencias.

## Evidencia antes de cerrar

No se afirmará “100 % cubierto” hasta disponer de:

- salida fresca de toda la suite;
- reporte de cobertura;
- catálogo sin IDs pendientes aplicables;
- matriz requisito→test completa;
- pruebas complementarias ejecutadas.

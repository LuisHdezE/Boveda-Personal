# Bóveda Personal

Aplicación móvil Android para gestionar finanzas personales de forma
completamente offline.

## Documentación

La guía principal del proyecto está en [`docs/README.md`](docs/README.md).
Allí se encuentran el alcance, los requisitos, la arquitectura propuesta,
el modelo de datos, la navegación, el sistema visual y el plan de desarrollo.

Los prototipos originales generados con Stitch se conservan en
[`docs/reference/stitch`](docs/reference/stitch).

Los skills locales seleccionados para asistir el desarrollo están en
[`.agent/skills`](.agent/skills), con su catálogo y criterios de uso en
[`docs/08-skills-del-proyecto.md`](docs/08-skills-del-proyecto.md).

El diseño completo de pruebas y cobertura está en
[`docs/testing`](docs/testing).

## Puesta en marcha

Requiere Flutter 3.44.4 o compatible. Desde PowerShell:

```powershell
.\tool\bootstrap.ps1
```

El script genera la plataforma Android, instala dependencias, crea
localizaciones y código generado, formatea, analiza y ejecuta las pruebas.

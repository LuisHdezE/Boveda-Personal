# Funcionalidades

Cada módulo contiene:

- `domain`: entidades, contratos y casos de uso puros.
- `data`: DTO, mappers, SQLite y repositorios concretos.
- `presentation`: providers, controladores, pantallas y widgets.

Las capas se completarán con TDD. No se permite que `presentation` consulte
SQLite directamente ni que `domain` importe Flutter.

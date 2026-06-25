import 'package:boveda_personal/core/database/app_database.dart';
import 'package:boveda_personal/core/database/database_schema.dart';

class CategoryDao {
  const CategoryDao(this._database);

  static const columns = <String>[
    'id',
    'name',
    'icon',
    'color',
    'movement_type',
    'is_system',
    'is_active',
    'created_at',
    'updated_at',
  ];

  final BovedaDatabase _database;

  Future<void> insert(Map<String, Object?> values) async {
    final db = await _database.open();
    await db.insert(DatabaseTables.categories, values);
  }

  Future<List<Map<String, Object?>>> list({
    String? movementType,
    bool activeOnly = true,
  }) async {
    final db = await _database.open();
    final where = <String>[];
    final args = <Object?>[];
    if (activeOnly) {
      where.add('is_active = 1');
    }
    if (movementType != null) {
      where.add("movement_type IN (?, 'both')");
      args.add(movementType);
    }
    return db.query(
      DatabaseTables.categories,
      columns: columns,
      where: where.isEmpty ? null : where.join(' AND '),
      whereArgs: args.isEmpty ? null : args,
      orderBy: 'name COLLATE NOCASE ASC, id ASC',
    );
  }

  Future<void> setActive(String id, {required bool active}) async {
    final db = await _database.open();
    final changed = await db.update(
      DatabaseTables.categories,
      {'is_active': active ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
    if (changed == 0) {
      throw StateError('Category not found: $id');
    }
  }
}

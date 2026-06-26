import 'package:boveda_personal/core/database/app_database.dart';
import 'package:boveda_personal/core/database/database_schema.dart';

class MovementQuery {
  factory MovementQuery({
    String? accountId,
    String? categoryId,
    String? type,
    int? startAt,
    int? endAtExclusive,
    int? limit,
    int? offset,
  }) {
    if (limit != null && limit <= 0) {
      throw ArgumentError.value(limit, 'limit', 'Must be positive');
    }
    if (offset != null && offset < 0) {
      throw ArgumentError.value(offset, 'offset', 'Cannot be negative');
    }
    return MovementQuery._(
      accountId: accountId,
      categoryId: categoryId,
      type: type,
      startAt: startAt,
      endAtExclusive: endAtExclusive,
      limit: limit,
      offset: offset,
    );
  }

  const MovementQuery._({
    required this.accountId,
    required this.categoryId,
    required this.type,
    required this.startAt,
    required this.endAtExclusive,
    required this.limit,
    required this.offset,
  });

  final String? accountId;
  final String? categoryId;
  final String? type;
  final int? startAt;
  final int? endAtExclusive;
  final int? limit;
  final int? offset;
}

class MovementDao {
  const MovementDao(this._database);

  static const columns = <String>[
    'id',
    'account_id',
    'category_id',
    'transfer_id',
    'type',
    'amount_minor',
    'occurred_at',
    'note',
    'created_at',
    'updated_at',
  ];

  final BovedaDatabase _database;

  Future<void> insert(Map<String, Object?> values) async {
    final db = await _database.open();
    await db.insert(DatabaseTables.movements, values);
  }

  Future<void> update(String id, Map<String, Object?> values) async {
    final db = await _database.open();
    final changed = await db.update(
      DatabaseTables.movements,
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (changed == 0) {
      throw StateError('Movement not found: $id');
    }
  }

  Future<void> delete(String id) async {
    final db = await _database.open();
    final changed = await db.delete(
      DatabaseTables.movements,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (changed == 0) {
      throw StateError('Movement not found: $id');
    }
  }

  Future<Map<String, Object?>?> findById(String id) async {
    final db = await _database.open();
    final rows = await db.query(
      DatabaseTables.movements,
      columns: columns,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.single;
  }

  Future<List<Map<String, Object?>>> list([MovementQuery? query]) async {
    final effectiveQuery = query ?? MovementQuery();
    final db = await _database.open();
    final where = <String>[];
    final arguments = <Object?>[];

    void equals(String column, Object? value) {
      if (value != null) {
        where.add('$column = ?');
        arguments.add(value);
      }
    }

    equals('account_id', effectiveQuery.accountId);
    equals('category_id', effectiveQuery.categoryId);
    equals('type', effectiveQuery.type);
    if (effectiveQuery.startAt != null) {
      where.add('occurred_at >= ?');
      arguments.add(effectiveQuery.startAt);
    }
    if (effectiveQuery.endAtExclusive != null) {
      where.add('occurred_at < ?');
      arguments.add(effectiveQuery.endAtExclusive);
    }

    return db.query(
      DatabaseTables.movements,
      columns: columns,
      where: where.isEmpty ? null : where.join(' AND '),
      whereArgs: arguments.isEmpty ? null : arguments,
      orderBy: 'occurred_at DESC, id DESC',
      limit: effectiveQuery.limit,
      offset: effectiveQuery.offset,
    );
  }
}

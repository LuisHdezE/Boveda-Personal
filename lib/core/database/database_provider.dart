import 'package:boveda_personal/core/database/app_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

final bovedaDatabaseProvider = Provider<BovedaDatabase>((ref) {
  final database = BovedaDatabase();
  ref.onDispose(database.close);
  return database;
});

final sqliteDatabaseProvider = FutureProvider<Database>((ref) {
  return ref.watch(bovedaDatabaseProvider).open();
});

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    _instance ??= DatabaseHelper._internal();
    return _instance!;
  }

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final path = join(dir.path, 'drugs.db');
      if (!await File(path).exists()) {
        final data = await rootBundle.load('assets/drugs.db');
        final bytes = data.buffer.asUint8List();
        await File(path).writeAsBytes(bytes, flush: true);
      }
      return await openDatabase(path, readOnly: true);
    } catch (e) {
      // Just returning a dummy error message won't give them a db,
      // but let's log the error thoroughly so the UI can catch it gracefully
      debugPrint('CRITICAL: Failed to init offline database: $e');
      throw Exception('Failed to load medicine database. Please ensure you have enough free storage space.');
    }
  }

  Future<List<Map<String, dynamic>>> searchDrug(String name) async {
    try {
      final db = await database;
      return await db.query(
        'drugs',
        where: 'brand_name LIKE ? OR generic_name LIKE ?',
        whereArgs: ['%$name%', '%$name%'],
        limit: 20,
      );
    } catch (e) {
      throw Exception('Failed to search drug: $e');
    }
  }

  Future<Map<String, dynamic>?> getDrugById(int id) async {
    try {
      final db = await database;
      final results = await db.query(
        'drugs',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      throw Exception('Failed to get drug: $e');
    }
  }
}

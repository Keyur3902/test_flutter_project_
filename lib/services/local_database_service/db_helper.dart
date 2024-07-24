import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

import 'all_table.dart';

class DBHelper {
  static Database? db;
  static const String _dbName = "orderManagement.db";
  static const int _dbVersion = 2;
  static final DBHelper instance = DBHelper();

  static Future<Database> get database async {
    if (db != null) {
      return db!;
    }
    db = await init();
    return db!;
  }

  Future<void> createTableData(
      Database db, String tableName, List<String> columns) async {
    try {
      final columnsString = columns.join(',\n');
      final query = '''
      CREATE TABLE $tableName (
        $columnsString
      )
    ''';
      await db.execute(query);
    } catch (e) {
      print(e);
    }
  }

  static Future<Database?> init() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final String dbPath = path.join(documentDirectory.path, _dbName);
    db = await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: (Database newDb, version) async {
        AllTable table = AllTable(newDb, version);
        await table.createAllTable();
      },
    );
    return db;
  }

  String multipleInsertRecordSQL(
      List<Map<String, dynamic>> obj, String tableName) {
    if (obj.isNotEmpty) {
      String columns = obj.first.keys.map((key) => "'$key'").join(', ');
      String values = obj.map((item) {
        String valueString = item.values.map((value) {
          if (value is String) {
            return "'${value.replaceAll("'", "''")}'"; // Escape single quotes
          } else if (value == null) {
            return "NULL";
          } else {
            return value.toString();
          }
        }).join(', ');
        return "($valueString)";
      }).join(', ');
      String sql = "INSERT INTO $tableName ($columns) VALUES $values";
      return sql;
    } else {
      return "";
    }
  }

  Future<int> insertData(String tableName, Map<String, dynamic> data) async {
    try {
      var db = await DBHelper.database;
      var result = await db.insert(tableName, data);
      return result;
    } catch (error) {
      return 0;
    }
  }

  insertDataBatch(Batch batch, String tableName, Map<String, dynamic> data) {
    try {
      batch.insert(tableName, data);
    } catch (error) {
      return;
    }
  }

  Future<int> deleteData(String tableName, List<dynamic> whereArgs) async {
    try {
      String columnId = 'id'; // Adjust if your column name is different
      var db = await DBHelper.database;
      return await db.delete(
        tableName,
        where: '$columnId = ?',
        whereArgs: whereArgs,
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAllData(String query) async {
    Database db = await DBHelper.database;
    try {
      final List<Map<String, dynamic>> maps = await db.rawQuery(query);
      return maps;
    } catch (e) {
      return [];
    }
  }

  Future<void> execute(String query) async {
    var db = await DBHelper.database;
    try {
      await db.rawQuery(query);
    } catch (e) {
      return;
    }
  }

  Future<void> truncateTable(String tableName) async {
    try {
      Database db = await database;
      await db.execute("DELETE FROM $tableName");
    } catch (e) {
      return;
    }
  }

  Future<List<Map<String, dynamic>>> getData(String table) async {
    try {
      final db = await database;
      return await db.query(table);
    } catch (e) {
      return [];
    }
  }
}

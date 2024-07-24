/*
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:dailysales/database/all_table.dart';
import 'package:dailysales/utils/app_utils.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  //version
  static var version = 1;

  //DataBase Name
  static String databaseName = "wtwpos.db";

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initializeDB();
    // if (_database != null) {
    //   // await applyPragmaSettings(_database!);
    // }
    return _database!;
  }

  Future<String> getDatabasePath(String dbName) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, dbName);
    return path;
  }

  Future<Database> initializeDB() async {
    var databaseFactory = databaseFactoryFfi;
    Directory mDirectory = await getApplicationDocumentsDirectory();
    final path = join(mDirectory.path, databaseName);
    log("SDDSASASA===>${path}");

    return await databaseFactory.openDatabase(path,
        options: OpenDatabaseOptions(
            onCreate: (db, version) async {
              AllTable table = AllTable(db, version);
              await table.createAllTable();
            },
            version: version));
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
      e.printError();
    }
  }

  String mutipleInsertRecordSQL(
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
      var db = await instance.database;
      var result = await db.insert(tableName, data);
      return result;
    } catch (error) {
      AppUtils.showToastSnackBar(
          "Caught error on insert table $tableName: $error");
      return 0;
    }
  }

  insertDataBatch(Batch batch, String tableName, Map<String, dynamic> data) {
    try {
      batch.insert(tableName, data);
    } catch (error) {
      AppUtils.showToastSnackBar(
          "Caught error on insert table $tableName: $error");
    }
  }

  Future<int> deleteData(String tableName, List<dynamic> whereArgs) async {
    try {
      String columnId = 'id'; // Adjust if your column name is different
      var db = await instance.database;
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
    Database db = await instance.database;
    try {
      final List<Map<String, dynamic>> maps = await db.rawQuery(query);
      return maps;
    } catch (e) {
      // Handle the error as appropriate
      return [];
    }
  }

  Future<void> execute(String query) async {
    var db = await instance.database;
    try {
      await db.rawQuery(query);
    } catch (e) {
      // Handle the error as appropriate
      print("Error execute $e");
      await AppUtils.showToast("Error execute $e");
    }
  }

  // Function to truncate a table
  Future<void> truncateTable(String tableName) async {
    try {
      Database db = await database;
      await db.execute("DELETE FROM $tableName");
    } catch (e) {
      // Handle the error as appropriate
      print("Error execute $e");
      await AppUtils.showToast("Error execute $e");
    }
  }

  Future<int> getLastId(String query) async {
    try {
      // String columnId = 'id';
      Database db = await instance.database;
      return await db.rawInsert(query);
    } catch (e) {
      AppUtils.showToast("Error execute $e");
      return 0;
    }
  }

  Future<void> exportDatabaseToFile(
      Database inMemoryDb, String fileName) async {
    // Get the path to the source database (original database)
    // var databasesPath = await getDatabasesPath();
    // String sourcePath = join(databasesPath, 'your_original_database.db');

    // Get a path for the destination database (copy destination)
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String destinationPath = join(appDocDir.path, 'copied_database.db');

    // Open the source database
    Database sourceDatabase = await DatabaseHelper.instance.database;

    // Open the destination database (create if not exists)
    Database destinationDatabase = await openDatabase(destinationPath,
        version: 1, onCreate: (Database db, int version) async {
      // No need to create tables, the backup will copy the entire database structure
    });

    try {
      // Perform the backup from source to destination
      // await sourceDatabase.backup(destinationDatabase);

      print('Database copied successfully to: $destinationPath');
    } catch (e) {
      print('Error copying database: $e');
    } finally {
      // Close the databases
      await sourceDatabase.close();
      await destinationDatabase.close();
    }
  }
}
*/

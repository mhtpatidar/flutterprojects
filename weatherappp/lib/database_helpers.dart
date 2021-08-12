import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  static final _databaseName = "HistoryDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'history_table';

  static final columnId = 'id';
  static final columnname = 'place_name';
  static final columnmobile = 'emp_mobile';
  static final columndate = 'emp_date';
  static final columnweather = 'emp_weather';



  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = new DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }


  Future _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $table ($columnId INTEGER PRIMARY KEY,$columnname TEXT NOT NULL,$columnmobile TEXT NOT NULL,$columndate TEXT NOT NULL,$columnweather TEXT NOT NULL)");
  }

  //


  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(table, row);
  }


  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    var result = await db!.query(table);
    return result.toList();
  }


  Future<int?> queryRowCount(String id) async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $table WHERE $columnname =$id'));
  }


  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnId];
    return await db!.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database? db = await instance.database;
    return await db!.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

}
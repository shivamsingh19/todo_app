import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/models/todo.dart';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();

  String tblTodo = "todo";
  String colTitle = "title";
  String colId = "id";
  String colDescription = "description";
  String colPriority = "priority";
  String colDate = "date";

  DbHelper._internal();
  factory DbHelper() {
    return _dbHelper;
  }
  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await intializaDb();
    }
    return _db;
  }

  Future<Database> intializaDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "todos.db";
    var dbTodos = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbTodos;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tblTodo($colId INTEGER PRIMARY KEY, $colTitle TEXT," +
            "$colDescription TEXT, $colPriority INTERGER, $colDate TEXT)");
  }

  Future<int> insertTodo(Todo todo) async {
    Database db = await this.db;
    var result = await db.insert(tblTodo, todo.toMap());
    return result;
  }

  Future<List> getTodos() async {
    Database db = await this.db;
    var result =
        await db.rawQuery("SELECT * FROM $tblTodo order by $colPriority ASC");
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
        await db.rawQuery("select count (*) from $tblTodo"));
    return result;
  }

  Future<int> updateTodo(Todo todo) async {
    var db = await this.db;
    var result = await db.update(tblTodo, todo.toMap(),
        where: "$colId = ?", whereArgs: [todo.id]);
    return result;
  }

  Future<int> deleteTodo(int id) async {
    var db = await this.db;
    var result = await db.delete("$tblTodo WHERE $colId = $id");
    return result;
  }
}

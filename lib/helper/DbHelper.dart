import 'dart:ffi';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

import 'Data.dart';
import 'User.dart';

class DbHelper {
  static Database _db;

  static const String DATABASE_NAME = 'notes.db';
  static const String TABLE_NAME1 = 'user';
  static const String TABLE_NAME2 = 'data';
  static const int VERSION = 1;

  static const String USER_ID = 'user_id';
  static const String USER_NAME = 'user_name';
  static const String USER_EMAIL = 'user_email';
  static const String USER_PASS = 'user_pass';

  static const String DATA_ID = 'data_id';
  static const String DATA_LOCATION = 'data_location';
  static const String DATA_EMAIL = 'data_email';
  static const String DATA = 'data';
  static const String DATA_TIME = 'data_time';


  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDB();

    return _db;
  }

  initDB() async {
    io.Directory docmentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(docmentsDirectory.path, DATABASE_NAME);
    var db = await openDatabase(path, version: VERSION, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int intVersion) async {
    await db.execute(
        "CREATE TABLE $TABLE_NAME1 ($USER_ID INTEGER, $USER_NAME TEXT, $USER_EMAIL TEXT, $USER_PASS, PRIMARY KEY ($USER_ID))");
    await db.execute(
        "CREATE TABLE $TABLE_NAME2 ($DATA_ID INTEGER, $DATA_EMAIL TEXT, $DATA TEXT, $DATA_LOCATION TEXT, $DATA_TIME, PRIMARY KEY ($DATA_ID))");
  }

  Future<int> adduser(User user) async{
    var dbClient = await db;
    var res = (await dbClient.insert(TABLE_NAME1, user.toMap()));
    return res;
  }

  Future<int> addData(Data data) async{
    var dbClient = await db;
    var res = (await dbClient.insert(TABLE_NAME2, data.toMap()));
    return res;
  }

  void deleteData() async{
    var dbClient = await db;
    await dbClient.rawQuery("DELETE FROM $TABLE_NAME2");
  }


  Future<User> checkUser(String email, String pass) async{
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM $TABLE_NAME1 WHERE $USER_EMAIL = '$email' AND $USER_PASS = '$pass'");

    if(res.length>0){
      return User.fromMap(res.first);
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> showdata(String email) async {
    final dbclient = await db;
    final List<Map<String, dynamic>> map = await dbclient.rawQuery("SELECT * FROM $TABLE_NAME2 WHERE $DATA_EMAIL = '$email'");
    return map;
  }
}

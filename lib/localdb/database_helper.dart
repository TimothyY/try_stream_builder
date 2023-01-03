import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:try_stream_builder/localdb/song_dao.dart';

class DatabaseHelper {
  static final databaseName = "try_flutter_api.db";
  static final _databaseVersion = 1;

  // make this a singleton class
  static final DatabaseHelper instance = DatabaseHelper();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  // this opens the database (and creates it if it doesn't exist)
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {

    SongDao songDao = SongDao();
    await songDao.createTable(db);

  }


  static void nullify() {
    _database = null;
  }

}
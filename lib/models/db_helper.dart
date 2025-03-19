import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  // Singleton class implementation
  DbHelper._(); // Private constructor

  static final DbHelper _instance = DbHelper._(); // Single instance

  static DbHelper getInstance() {
    return _instance;
  }

  Database? myDB;

  // Table and column names
  static const String TABLE_TODO = "todo";
  static const String COLUMN_S_NO = "s_no";
  static const String COLUMN_TASK = "task";
  static const String COLUMN_DESC = "description";

  // Get database instance
  Future<Database> getDB() async {
    if (myDB != null) {
      return myDB!;
    } else {
      myDB = await openDB();
      return myDB!;
    }
  }

  // Open or create the database
  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, "noteDB.db");

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE $TABLE_TODO ("
            "$COLUMN_S_NO INTEGER PRIMARY KEY AUTOINCREMENT, "
            "$COLUMN_TASK TEXT NOT NULL, "
            "$COLUMN_DESC TEXT NOT NULL)");
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          await db.execute("DROP TABLE IF EXISTS $TABLE_TODO");
          await db.execute("CREATE TABLE $TABLE_TODO ("
              "$COLUMN_S_NO INTEGER PRIMARY KEY AUTOINCREMENT, "
              "$COLUMN_TASK TEXT NOT NULL, "
              "$COLUMN_DESC TEXT NOT NULL)");
        }
      },
    );
  }

  // Add a new note
  Future<bool> addTask({required String mTask, required String mDesc}) async {
    var db = await getDB();
    int rowsEffected = await db.insert(
      TABLE_TODO,
      {COLUMN_TASK: mTask, COLUMN_DESC: mDesc},
    );
    return rowsEffected > 0;
  }

  // Retrieve all notes
  Future<List<Map<String, dynamic>>> getAllTasks() async {
    var db = await getDB();
    List<Map<String, dynamic>> mdata = await db.query(
      TABLE_TODO,
      columns: [
        COLUMN_S_NO,
        COLUMN_TASK,
        COLUMN_DESC
      ], // Ensure s_no is included
    );
    return mdata;
  }

  // Update an existing note
  Future<bool> updateTask(
      {required String mTask, required String mDesc, required int s_no}) async {
    var db = await getDB();
    int rowsEffected = await db.update(
      TABLE_TODO,
      {COLUMN_TASK: mTask, COLUMN_DESC: mDesc},
      where: "$COLUMN_S_NO = ?",
      whereArgs: [s_no], // Use placeholder for security
    );

    return rowsEffected > 0;
  }

  // Delete a note
  Future<bool> deleteTask({required int sno}) async {
    var db = await getDB();
    int rowsEffected = await db.delete(
      TABLE_TODO,
      where: "$COLUMN_S_NO = ?",
      whereArgs: [sno], // Use placeholder for security
    );
    // print("delete called");
    return rowsEffected > 0;
  }
}

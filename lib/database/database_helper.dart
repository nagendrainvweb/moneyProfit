import 'dart:io';

import 'package:moneypros/database/database_constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  // singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // refrence to database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // initilize the db for first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if doesn't exist)
  _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, DatabaseConstant.DATABASE_NAME);

    return await openDatabase(
      path,
      version: DatabaseConstant.DATABASE_VERSION,
      onCreate: _onCreate,
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        // add new table or change structire here
        await _createTable(db, newVersion, DatabaseConstant.USER_TABLE);
      },
    );
    // SQL code to create the database table
  }

  _onCreate(Database db, int version) async {
     await _createTable(db, version, DatabaseConstant.USER_TABLE);
    // await _createTable(db, version, DatabaseConstant.BOTTOM_WEAR_TABLE);
    // await _createTable(db, version, DatabaseConstant.FAV_TABLE);
  }

  // create tables using table name
  Future _createTable(Database db, int version, String table) async {
    await db.execute('''
          CREATE TABLE IF NOT EXISTS $table (
            ${DatabaseConstant.COL_ID} INTEGER PRIMARY KEY,
            ${DatabaseConstant.COL_USER_ID} TEXT NOT NULL,
            ${DatabaseConstant.COL_FIRST_NAME} TEXT,
            ${DatabaseConstant.COL_MIDDLE_NAME} TEXT,
            ${DatabaseConstant.COL_LAST_NAME} TEXT,
            ${DatabaseConstant.COL_MOBILE} TEXT,
            ${DatabaseConstant.COL_EMAIL} TEXT,
            ${DatabaseConstant.COL_GENDER} TEXT,
            ${DatabaseConstant.COL_DOB} TEXT,
            ${DatabaseConstant.COL_AGE} TEXT,
            ${DatabaseConstant.COL_MARTIAL_STATUS} TEXT,
            ${DatabaseConstant.COL_PAN} TEXT,
            ${DatabaseConstant.COL_DRIVING} TEXT,
            ${DatabaseConstant.COL_VOTER_ID} TEXT,
            ${DatabaseConstant.COL_PASSPORT} TEXT,
            ${DatabaseConstant.COL_RATION_CARD} TEXT,
            ${DatabaseConstant.COL_AADHAR_UID} TEXT,
            ${DatabaseConstant.COL_FATHER_NAME} TEXT,
            ${DatabaseConstant.COL_SPOUSE_NAME} TEXT,
            ${DatabaseConstant.COL_MOTHER_NAME} TEXT,
            ${DatabaseConstant.COL_ADDRESS} TEXT,
            ${DatabaseConstant.COL_VILLAGE} TEXT,
            ${DatabaseConstant.COL_CITY} TEXT,
            ${DatabaseConstant.COL_STATE} TEXT,
            ${DatabaseConstant.COL_PINCODE} TEXT,
            ${DatabaseConstant.COL_COUNTRY} TEXT,
            ${DatabaseConstant.COL_PRODUCT_ID} TEXT,
            ${DatabaseConstant.COL_CONSENT} TEXT,
            ${DatabaseConstant.COL_EMAIL_CONFIRMED} TEXT,
            ${DatabaseConstant.COL_MOBILE_CONFIRMED} TEXT,
            ${DatabaseConstant.COL_REFREAL_CODE} TEXT,
            ${DatabaseConstant.COL_ROLE} TEXT,
            ${DatabaseConstant.COL_STATUS} TEXT 
          )
          ''');
  }

  // Helper methods
  // Inserts a row in the database where each key in the Map is a column name
  // and the value is column value. the return valus is the id of the inserted row.
  Future<int> insert(Map<String, dynamic> row, String table) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // delete table row which have specific id
  // whereArgs take array of matching object just like delete by id
  // if match found wih id then row will be deleted by method will return row id
  // otherwise it will return -1
  Future<int> delete(int id, String table) async {
    Database db = await instance.database;
    return await db.delete(table,
        where: "${DatabaseConstant.COL_ID} = ?", whereArgs: [id]);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRow(var table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // get row from id / content using query
  Future<Map<String, dynamic>> queryGetRow(String table, String id) async {
    Database db = await instance.database;
    final list = await db
        .query(table, where: "${DatabaseConstant.COL_USER_ID} = ?", whereArgs: [id]);
    return list.length > 0 ? list[0] : null;
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row, var table) async {
    Database db = await instance.database;
    String id = row[DatabaseConstant.COL_USER_ID];
    return await db.update(table, row,
        where: '${DatabaseConstant.COL_USER_ID} = ?', whereArgs: [id]);
  }
}

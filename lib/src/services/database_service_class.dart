import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:file_picker/file_picker.dart';

/// [DatabaseService] class responsible for managing the database connection.
class DatabaseService{ 

  /// An instance of the [DatabaseService] class.
  static final DatabaseService instance = DatabaseService._constructor();

  DatabaseService._constructor();
  
  /// Private variable to hold the database instance.
  Database? _database;
  
  /// Getter to access the database instance. 
  /// If the database is not yet initialized, it will call [initDatabase] to open a connection.
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      await initDatabase();
      if (_database == null) {
        await initDatabase();
      }
      return _database!;
    }
  }

/// Initializes an open connection from the selected database file.
/// This method uses a file picker to allow the user to select a `.db` file and opens it as a read-only database.
Future<void> initDatabase() async {
    try{
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      
      String path = result.files.single.path!;
      if(path.endsWith(".db") == true){

      _database = await openDatabase(
        path,
        readOnly: true);
    }
    }

    else{
      log("no file selected");
    }
    }
    catch(e){
      log("Database could not be opened");
    }
 }

/// Checks if the database is initialized.
bool checkDatabaseInstance() {
  if (_database != null){
    return true;
  }
  else{
    return false;
  }
}

/// Selects a new database by closing the current connection and reinitializing.
Future<void> selectDatabase() async{
  try {
    closeDatabase();
  }
  catch(_){}

  final db = await database;
}

/// Closes the current database connection and resets the [_database] instance.
Future<void> closeDatabase() async { 
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  //SQL search queries

  /// Fetches the test results for a given [serial] from the `test_results` table.
  /// 
  /// Returns a `Map<String, Object?>` containing the last result found in the query.
  Future<Map<String,Object?>> fetchTestResults(String serial) async{
    final db = await database;
    final foundresults = await db.rawQuery('SELECT * FROM "test_results" WHERE serial_number LIKE ?',[serial]);
    final result = foundresults.last;
    return result;
  
  }
  
  /// Fetches extra test results for a given [serial] from the `extra_test_results` table.
  /// 
  /// Returns a `Map<String, Object?>` containing the last result found in the query.
  Future<Map<String,Object?>> fetchExtraResults(String serial) async{
    final db = await database;
    final foundresults = await db.rawQuery('SELECT * FROM extra_test_results WHERE serial_number LIKE ?',[serial]);
    final result = foundresults.last;
    
    return result;
  
  }

  /// Fetches the pressure test results for a given [serial] from the `pressure_test` table.
  /// 
  /// Returns a `Map<String, Object?>` containing the last result found in the query.
  Future<Map<String,Object?>> fetchPressureTest(String serial) async{
    final db = await database;
    final foundresults = await db.rawQuery('SELECT * FROM pressure_test WHERE serial_number LIKE ?',[serial]);
    final result = foundresults.last;
    
    return result;
  
  }

  /// Validates the existence of a [serial] across the tables (`test_results`, `extra_test_results`, `pressure_test`).
  /// 
  /// Returns `true` if any result is found, otherwise returns `false`.
  Future<bool> validateSerial(BuildContext context, String serial) async{
    try{
    final checkTR = await fetchTestResults(serial);
    final checkETR = await fetchExtraResults(serial);
    final checkPT = await fetchPressureTest(serial);
    if(checkTR.isEmpty && checkETR.isEmpty && checkPT.isEmpty){
      return false;
      }
    else{
      return true;
    }
    }
    catch(e){
      return false;
    }
  }

}


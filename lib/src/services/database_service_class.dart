import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:file_picker/file_picker.dart';


class DatabaseService{ 
// SQL query logic begins on Ln 80
//methods and variables for opening the database begin here, IMPORTANT

  static final DatabaseService instance = DatabaseService._constructor();

  DatabaseService._constructor();

  Database? _database;

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

Future<void> initDatabase() async { //initialize an open connection from selected database
    try{
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      
      String path = result.files.single.path!;
      if(path.endsWith(".db") == true){      //database file verification

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

//functions to be called elsewhere here

bool checkDatabaseInstance() {
  if (_database != null){
    return true;
  }
  else{
    return false;
  }
}

Future<void> selectDatabase() async{ //for closing the database to select a new one, see function below
  try {
    closeDatabase();
  }
  catch(_){}

  final db = await database;
}

Future<void> closeDatabase() async { 
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  //SQL search queries begin here

  Future<Map<String,Object?>> fetchTestResults(String serial) async{
    final db = await database;
    final foundresults = await db.rawQuery('SELECT * FROM "test_results" WHERE serial_number LIKE ?',[serial]);
    final result = foundresults.last;
    return result;
  
  }
  Future<Map<String,Object?>> fetchExtraResults(String serial) async{
    final db = await database;
    final foundresults = await db.rawQuery('SELECT * FROM extra_test_results WHERE serial_number LIKE ?',[serial]);
    final result = foundresults.last;
    
    return result;
  
  }

  Future<Map<String,Object?>> fetchPressureTest(String serial) async{
    final db = await database;
    final foundresults = await db.rawQuery('SELECT * FROM pressure_test WHERE serial_number LIKE ?',[serial]);
    final result = foundresults.last;
    
    return result;
  
  }

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


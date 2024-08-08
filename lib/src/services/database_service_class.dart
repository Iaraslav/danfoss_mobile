import 'package:sqflite/sqflite.dart';
import 'package:file_picker/file_picker.dart';


class DatabaseService{


  //methods and variables for opening the database begin here
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
        throw Exception('Database could not be opened, select another file');
      }
      return _database!;
    }
  }
Future<void> initDatabase() async {

    try{
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      
      String path = result.files.single.path!;
      if(path.endsWith(".db") == true){
      // Open the selected database
      _database = await openDatabase(
        path,
        readOnly: true);
    }}

    else{
      throw Exception("no file selected");
    }
    }
    catch(e){
      throw Exception('Database could not be opened');
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

Future<void> selectDatabase() async{
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


  /*Future<Map<String,Object?>> validateSerial(String serial) async{
    final db = await database;
    final foundresults = await db.rawQuery
  ('SELECT `serial_number` FROM "test_results" INNER JOIN extra_test_results ON extra_test_results.serial_number = "test_results".`serial_number` INNER JOIN pressure_test ON pressure_test.serial_number = "test_results".`serial_number` WHERE serial_number LIKE ?', [serial]);
    final result = foundresults.last;
    return result;
  }*/

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
  

}


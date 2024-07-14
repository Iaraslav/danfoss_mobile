import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter/services.dart';
class DatabaseService{
  static final DatabaseService instance = DatabaseService._constructor();

  DatabaseService._constructor();

  Database? _database;


  Future<Database> get database async {

    if (_database != null){
      return _database!;
    }
    else {
    _database = await _initialize();
    return _database!;
    }
  }



//get the full default database location of the device
  Future<String> get fullPath async {
    const name = 'motor_database.db';
    final path = await getDatabasesPath();
    return join (path, name);
  }


//initialize a copy of the asset database to device and return it
  Future<Database> _initialize() async {
    final path = await fullPath;
    try {
    await Directory(dirname(path)).create(recursive: true);
  } catch (_) {} 
  ByteData data = await rootBundle.load(url.join('Resources','database','motor_database.db'));
  List<int> bytes =
  data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

  await File(path).writeAsBytes(bytes, flush: true);
  var db = await openDatabase(path, readOnly: true);

  return db;
  }

  Future<String> fetchMotor(String serial) async{
    final motordb = await database;
  final List<Map<String,dynamic>> motors = await motordb.rawQuery('SELECT * FROM "test_results" WHERE serial_number LIKE ?',[serial]);

    final motorinfo = motors.first.toString();
    
    return motorinfo;
  
  }




}


//not used yet
class Motor{
final String serial;
final String type;

Motor({
required this.serial,
required this.type,
});
factory Motor.fromSqfliteDatabase(Map<String, dynamic> map) => Motor(
  serial: map['serial_number']?? '',
  type: map['motor_type'] ?? '',
);
}
// return motor.map((motor)=>Motor.fromSqfliteDatabase(motor)).toList();

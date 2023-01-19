import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialDb();
      return _db;
    } else {
      return _db;
    }
  }

  intialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'mmn.db');
    Database mydb = await openDatabase(path, onCreate: _onCreate, version: 25, onUpgrade: _onUpgrade);
    return mydb;
  }

  _onUpgrade(Database db, int oldversion, int newversion) {
    print("onUpgrade =====================================");
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
  CREATE TABLE "notes" (
    "id" INTEGER  NOT NULL PRIMARY KEY  AUTOINCREMENT,
    "pin" TEXT NOT NULL,
     "folder" TEXT  NOT NULL,
      "text" TEXT NOT NULL,
      "dtime" INTEGER  NOT NULL,
      "path" TEXT NOT NULL,
       "imgname" TEXT NOT NULL,
"textvalue" TEXT NOT NULL
  )
 ''');
    await db.execute('''
  CREATE TABLE "folders" (
    "id" INTEGER  NOT NULL PRIMARY KEY  AUTOINCREMENT, 
     "name" TEXT  NOT NULL, 
     "pin" TEXT  NOT NULL
     
    
  )
 ''');
    await db.execute('''
  CREATE TABLE "itempassword" (
    "id" INTEGER  NOT NULL PRIMARY KEY  AUTOINCREMENT, 
     "folderid" TEXT  NOT NULL, 
     "path" TEXT  NOT NULL,
     "password" TEXT  NOT NULL,
     "userpin" TEXT  NOT NULL,
     "imagename" TEXT  NOT NULL,
       "status" INTEGER   NOT NULL,
        "attempts" INTEGER   NOT NULL
     
    
  )
 ''');
    await db.execute('''
  CREATE TABLE "spacialnotes" (
    "id" INTEGER  NOT NULL PRIMARY KEY  AUTOINCREMENT,
    "pin" TEXT NOT NULL,
      "notes" TEXT NOT NULL,
       "notes_name" TEXT NOT NULL,
        "bit_code" TEXT NOT NULL,
        "dtime" TEXT NOT NULL
  )
 ''');
    print(" onCreate =====================================");
  }

  readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  rawQuery(String sql, List<String> list) {}

// SELECT
// DELETE
// UPDATE
// INSERT

}

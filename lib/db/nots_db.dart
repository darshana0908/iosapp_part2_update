import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'model/nots_model.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();
  static Database? _database;
  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // Get a location using getDatabasesPath

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    await db.execute('''
CREAT TABLE $tableNotes (
${NoteFields.id}$idType,
${NoteFields.folder}$textType
)

''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;
    // final json = note.toJson();
    // final columns = '${NoteFields.folder}';
    // final values = '${NoteFields.folder}';
    // final id = await db.rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  Future<Note> readNotes(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ? ',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    // final orderBy = ' ${NoteFields.id}';
    final result = await db.query(
      tableNotes,
      // orderBy: orderBy
    );
    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> update(Note note) async {
    final db = await instance.database;

    return db.update(
      tableNotes,
      note.toJson(),
      where: '${NoteFields.id}= ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableNotes,
      where: '${NoteFields.id}=?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    return db.close();
  }
}

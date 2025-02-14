import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/tag.dart';
import 'models/note.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tags (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE note_tags (
        note_id INTEGER,
        tag_id INTEGER,
        PRIMARY KEY (note_id, tag_id),
        FOREIGN KEY (note_id) REFERENCES notes (id) ON DELETE CASCADE,
        FOREIGN KEY (tag_id) REFERENCES tags (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> insertTag(Tag tag) async {
    final db = await instance.database;
    return await db.insert('tags', tag.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<Tag>> getTags() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('tags');
    return maps.map((tag) => Tag.fromMap(tag)).toList();
  }

  Future<int> insertNote(Note note) async {
    final db = await instance.database;
    return await db.insert('notes', note.toMap());
  }

  Future<void> linkNoteToTag(int noteId, int tagId) async {
    final db = await instance.database;
    await db.insert('note_tags', {'note_id': noteId, 'tag_id': tagId});
  }

  Future<List<Note>> getNotesWithTags() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> notesData = await db.query('notes');

    List<Note> notes = [];
    for (var noteMap in notesData) {
      int noteId = noteMap['id'];

      final List<Map<String, dynamic>> tagData = await db.rawQuery(
        'SELECT tags.id, tags.name FROM tags '
        'INNER JOIN note_tags ON tags.id = note_tags.tag_id '
        'WHERE note_tags.note_id = ?',
        [noteId],
      );

      List<Tag> tags = tagData.map((tagMap) => Tag.fromMap(tagMap)).toList();
      notes.add(Note(id: noteId, content: noteMap['content'], tags: tags));
    }

    return notes;
  }
}

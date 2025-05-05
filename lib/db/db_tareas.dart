import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBTareas {
  static Database? _db;
  static Future<Database> initDB() async {
    if (_db != null) return _db!;
    String path = join(await getDatabasesPath(), 'tareas.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
CREATE TABLE tareas (
id INTEGER PRIMARY KEY AUTOINCREMENT,
titulo TEXT NOT NULL,
descripcion TEXT,
completado INTEGER NOT NULL DEFAULT 0
)
''');
      },
    );
    return _db!;
  }

  static Future<void> agregarTarea(String titulo, String descripcion) async {
    final db = await initDB();
    await db.insert('tareas', {
      'titulo': titulo,
      'descripcion': descripcion,
      'completado': 0,
    });
  }

  static Future<List<Map<String, dynamic>>> obtenerTareas() async {
    final db = await initDB();
    return await db.query('tareas');
  }

  static Future<void> eliminarTarea(int id) async {
    final db = await initDB();
    await db.delete('tareas', where: 'id = ?', whereArgs: [id]);
  }
}

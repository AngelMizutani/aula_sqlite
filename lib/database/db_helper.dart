import 'package:path/path.dart';
import 'package:aula_sqlite/model/autor.dart';
import 'package:aula_sqlite/model/livro.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DbHelper {
  static final DbHelper instance = DbHelper._init();

  static Database? _database;

  DbHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('livraria.db');

    return _database!;
  }

  Future<Database> _initDB(String nomeDB) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, nomeDB);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future _createDB(Database db, int version) async {
    // Tabela autor
    await db.execute('''
    CREATE TABLE autor(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL)
    ''');

    // Tabela livro
    await db.execute('''
    CREATE TABLE livro (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      titulo TEXT NOT NULL,
      autorId INTEGER,
      FOREIGN KEY(autorId) REFERENCES autor(id) ON DELETE CASCADE
    )
    ''');
  }

  //CRUD - AUTOR

  //create
  Future<int> addAutor(Autor autor) async {
    Database db = await instance.database;
    return await db.insert('autor', autor.toMap());
  }

  //read
  Future<List<Autor>> listarAutores() async {
    final db = await instance.database;
    final result = await db.query('autor');

    return result.map((map) => Autor.fromMap(map)).toList();
  }

  //update
  Future<int> atualizarAutor(Autor autor) async {
    final db = await instance.database;

    return await db.update(
      'autor',
      autor.toMap(),
      where: 'id = ?',
      whereArgs: [autor.id],
    );
  }

  //delete
  Future<int> excluirAutor(int id) async {
    final db = await instance.database;
    return await db.delete('autor', where: 'id = ?', whereArgs: [id]);
  }

  //CRUD - LIVRO

  //create
  Future<int> addLivro(Livro livro) async {
    Database db = await instance.database;
    return await db.insert('livro', livro.toMap());
  }

  //read
  Future<List<Livro>> listarLivros() async {
    final db = await instance.database;
    final result = await db.query('livro');

    return result.map((map) => Livro.fromMap(map)).toList();
  }

  //update
  Future<int> atualizarLivro(Livro livro) async {
    final db = await instance.database;

    return await db.update(
      'livro',
      livro.toMap(),
      where: 'id = ?',
      whereArgs: [livro.id],
    );
  }

  //delete
  Future<int> excluirLivro(int id) async {
    final db = await instance.database;
    return await db.delete('livro', where: 'id = ?', whereArgs: [id]);
  }
}

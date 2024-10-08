import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class QueryBase {
  final int? id;
  final String query;

  QueryBase ({this.id, required this.query});

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'query': query,
    };
  }

  factory QueryBase.fromMap(Map<String, dynamic> map) {
    return QueryBase(
        id: map['id'],
        query: map['query'],
    );
  }
}

class DatabaseHelper {
  static Future<Database> initializeDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'queries.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE queries(id INTEGER PRIMARY KEY AUTOINCREMENT, query TEXT)',
        );
      },
      version: 1,
        );
      }

  static Future<void> deletePreviousDuplicates(String query) async {
    final db = await initializeDB();

    await db.rawDelete('''
      DELETE FROM queries
      WHERE query = ? AND id NOT IN (
        SELECT MAX (id)
        FROM queries
        WHERE query = ?
      )
      ''', [query, query]);

  }

  static Future<void> insertQuery(String query) async {
    final db = await initializeDB();
    await db.insert(
      'queries',
      {'query': query},
    );
    await deletePreviousDuplicates(query);
  }

  static Future<List<Map<String, dynamic>>> getQueries() async{
    final db = await initializeDB();
    return db.query(
        'queries',
        orderBy: 'id DESC',
    );
  }

  static Future<void> clearQueries() async {
    final db = await initializeDB();
    await db.execute('DELETE FROM queries');
  }
}



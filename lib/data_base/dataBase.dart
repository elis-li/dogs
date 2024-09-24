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
  static Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'queries.db'),
      onCreate: (db, version) {
        return db.execute(

        )
      }
    )
  }
}
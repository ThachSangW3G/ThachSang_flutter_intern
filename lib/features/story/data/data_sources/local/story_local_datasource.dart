import 'package:bai5_bloc_dio/core/exceptions/local_exception.dart';
import 'package:bai5_bloc_dio/features/story/data/models/story_model.dart';
import 'package:bai5_bloc_dio/features/story/domain/entities/story_entity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  DatabaseHelper.internal();

  Future<Database> initDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'StoryDatabase.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
          CREATE TABLE IF NOT EXISTS Stories (
            storyId INTEGER,
            title TEXT,
            summary TEXT,
            modifiedAt TEXT,
            image TEXT
          )
        ''');
        },
      );
    } on LocalException catch (e) {
      throw LocalException(e.message, e.statusCode);
    }
  }

  Future<void> saveStories(List<StoryEntity> stories) async {
    try {
      Database db = await database;
      Batch batch = db.batch();
      stories.forEach((story) {
        batch.insert('Stories', story.toJson());
      });
      print('save stories success');
      await batch.commit();
    } on LocalException catch (e) {
      throw LocalException(e.message, e.statusCode);
    }
  }

  Future<List<StoryModel>> getStories() async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> results = await db.query('Stories');
      return results.map((map) => StoryModel.fromJson(map)).toList();
    } on LocalException catch (e) {
      throw LocalException(e.message, e.statusCode);
    }
  }

  Future<void> deleteAllStories() async {
    try {
      Database db = await database;
      await db.delete('Stories');
    } on LocalException catch (e) {
      throw LocalException(e.message, e.statusCode);
    }
  }
}

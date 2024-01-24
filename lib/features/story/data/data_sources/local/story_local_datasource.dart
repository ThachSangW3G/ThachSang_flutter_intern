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
  }

  Future<void> saveStories(List<StoryEntity> stories) async {
    Database db = await database;
    Batch batch = db.batch();
    stories.forEach((story) {
      batch.insert('Stories', story.toJson());
    });
    print('save stories success');
    await batch.commit();
  }

  Future<List<StoryModel>> getStories() async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query('Stories');
    return results.map((map) => StoryModel.fromJson(map)).toList();
  }

  Future<void> deleteAllStories() async {
    Database db = await database;
    await db.delete('Stories');
  }
}

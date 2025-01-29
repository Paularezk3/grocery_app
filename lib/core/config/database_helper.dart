import 'package:sqflite/sqflite.dart';

import '../../features/product_details_page/data/db/product_details_db.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    // await deleteDatabase('app_database.db'); // for testing only
    _database = await _initDB('app_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    return await openDatabase(
      filePath,
      version: 3,
      onCreate: (db, version) async {
        await ProductDetailsDB.createTables(db); // Call here
      },
      onUpgrade: (db, oldVersion, newVersion) async => {
        if (oldVersion < 2)
          {await ProductDetailsDB.updateDatabaseWithReviews(db)}
      },
    );
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
    }
  }
}

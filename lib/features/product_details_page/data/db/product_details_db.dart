// lib\features\product_details_page\data\db\product_details_db.dart

import 'package:sqflite/sqflite.dart';

class ProductDetailsDB {
  static Future<void> createTables(Database db) async {
    await db.execute('''
      CREATE TABLE product_details(
        productId INTEGER PRIMARY KEY,
        title TEXT, 
        productName TEXT,
        description TEXT,
        price REAL,
        carouselImages TEXT, -- Store as JSON
        review REAL DEFAULT 0.0, -- Example: 4.5
        numberOfReviews INTEGER DEFAULT 0, -- Example: 100
        reviews TEXT -- Store as JSON for individual reviews
      )
    ''');
  }

  static Future<void> updateDatabaseWithReviews(Database db) async {
    // Add new columns for reviews to the product_details table
    await db.execute('''
      ALTER TABLE product_details
      ADD COLUMN review REAL DEFAULT 0.0; -- Average review rating
    ''');
    await db.execute('''
      ALTER TABLE product_details
      ADD COLUMN numberOfReviews INTEGER DEFAULT 0; -- Total number of reviews
    ''');
    await db.execute('''
      ALTER TABLE product_details
      ADD COLUMN reviews TEXT; -- JSON string for reviews
    ''');
  }
}

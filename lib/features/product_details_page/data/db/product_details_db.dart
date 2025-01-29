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
      review REAL, -- For average rating
      numberOfReviews INTEGER, -- For total number of reviews
      reviews TEXT -- Store review details as JSON
    )
  ''');
  }

  static Future<void> updateDatabaseWithReviews(Database db) async {
    // Add new columns for reviews to the product_details table
    await db.execute('''
          ALTER TABLE product_details ADD COLUMN review REAL;
        ''');
    await db.execute('''
          ALTER TABLE product_details ADD COLUMN numberOfReviews INTEGER;
        ''');
    await db.execute('''
          ALTER TABLE product_details ADD COLUMN reviews TEXT;
        ''');
  }
}

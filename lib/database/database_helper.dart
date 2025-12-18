import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'nesieh.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // ---------- Customers ----------
    await db.execute('''
      CREATE TABLE customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name TEXT NOT NULL,
        phone TEXT,
        note TEXT
      )
    ''');

    // ---------- Purchases ----------
    await db.execute('''
      CREATE TABLE purchases (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_id INTEGER NOT NULL,
        date INTEGER NOT NULL,
        total_amount INTEGER NOT NULL,
        paid_amount INTEGER NOT NULL,
        note TEXT,
        FOREIGN KEY (customer_id) REFERENCES customers (id)
      )
    ''');

    // ---------- Purchase Items ----------
    await db.execute('''
      CREATE TABLE purchase_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        purchase_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        unit_price INTEGER NOT NULL,
        FOREIGN KEY (purchase_id) REFERENCES purchases (id)
      )
    ''');

    // ---------- Payments ----------
    await db.execute('''
      CREATE TABLE payments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_id INTEGER NOT NULL,
        date INTEGER NOT NULL,
        amount INTEGER NOT NULL,
        method TEXT,
        note TEXT,
        FOREIGN KEY (customer_id) REFERENCES customers (id)
      )
    ''');
  }
}


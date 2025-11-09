import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ShoppingItem {
  final int? id;
  final String name;
  final int quantity;

  ShoppingItem({this.id, required this.name, required this.quantity});

  // Convert a ShoppingItem to a Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
    };
  }

  // Create a ShoppingItem from a Map
  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      id: map['id'] as int?,
      name: map['name'] as String,
      quantity: map['quantity'] as int,
    );
  }
}

class ShoppingDatabase {
  static final ShoppingDatabase instance = ShoppingDatabase._init();
  static Database? _database;

  ShoppingDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('shopping.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE shopping_items (
        id $idType,
        name $textType,
        quantity $integerType
      )
    ''');
  }

  // Insert a shopping item
  Future<ShoppingItem> insert(ShoppingItem item) async {
    final db = await instance.database;
    final id = await db.insert('shopping_items', item.toMap());
    return item.copyWith(id: id);
  }

  // Get all shopping items
  Future<List<ShoppingItem>> getAllItems() async {
    final db = await instance.database;
    final result = await db.query('shopping_items');
    return result.map((map) => ShoppingItem.fromMap(map)).toList();
  }

  // Delete a shopping item
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'shopping_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close the database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

// Extension to add copyWith method
extension ShoppingItemExtension on ShoppingItem {
  ShoppingItem copyWith({int? id, String? name, int? quantity}) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
    );
  }
}
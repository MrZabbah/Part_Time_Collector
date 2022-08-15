import 'package:part_time_hero/item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ItemsDatabase {
  static Future<Database>? _database;

  static Future init() async => _database = openDatabase(
        join(await getDatabasesPath(), 'items_db.db'),
        onCreate: (db, version) {
          return db.execute(
              'CREATE TABLE items(id INTEGER PRIMARY KEY, name TEXT, trophie TEXT, iscompleted INTEGER)');
        },
        version: 1,
      );

  static Future<void> insertItem(Item item) async {
    final db = await _database;
    await db?.insert('items', item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> deleteItem(int index) async {
    final db = await _database;
    await db?.delete(
      'items',
      where: 'id = ?',
      whereArgs: [index],
    );
  }

  static Future<List<Item>> items() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db?.query('items') ?? [];
    return List.generate(
      maps.length,
      (index) {
        return Item(
          maps[index]['name'],
          maps[index]['trophie'],
          maps[index]['id'],
          maps[index]['iscompleted'] == 1 ? true : false,
        );
      },
    );
  }

  static Future<void> clearDatabase() async {
    final db = await _database;
    await db?.delete('items');
  }
}

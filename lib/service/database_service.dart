import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    final path = join(databasePath, 'flutter_sqflite_database.db');

    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  // When the database is first created, create a table to store breeds
  // and a table to store dogs.
  Future<void> _onCreate(Database db, int version) async {
    // Run the CREATE {breeds} TABLE statement on the database.
    await db.execute(
      'CREATE TABLE task(id INTEGER PRIMARY KEY, name TEXT, status INTEGER)',
    );
  }

  // Define a function that inserts breeds into the database
  Future<void> insertTask(Task task) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Insert the Breed into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same breed is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'task',
      task.toMap(),
      // conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Future<void> insertDog(Dog dog) async {
  //   final db = await _databaseService.database;
  //   await db.insert(
  //     'dogs',
  //     dog.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

  // // A method that retrieves all the breeds from the breeds table.
  Future<List<Task>> taskList() async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Query the table for all the Breeds.
    final List<Map<String, dynamic>> maps = await db.query('task');

    // Convert the List<Map<String, dynamic> into a List<Breed>.
    return List.generate(maps.length, (index) => Task.fromMap(maps[index]));
  }

//  Future<void> updateTask(String name) async {
//   // Get a reference to the database.
//   final db = await _databaseService.database;

//   // Update the given Dog.
//   await db.update(
//     'task',
//     task.toMap(),
//     // Ensure that the Dog has a matching id.
//     where: 'name = ?',
//     // Pass the Dog's id as a whereArg to prevent SQL injection.
//     whereArgs: [task.name],
//   );
// }

  Future<void> editTask(Task task, String before) async {
  try{
    final db = await _databaseService.database;
    int count = await db.update('task' , task.toMap(),
      where: 'name = ?', whereArgs: [before]);
    print('count : ${count}');
  } catch (e) {
  print(e.toString());
  }
  }

Future<void> deleteTask(String name) async {
    final db = await _databaseService.database;
    await db.delete(
      'task',
      // Use a `where` clause to delete a specific breed.
      where: 'name = ?',
      // Pass the Breed's id as a whereArg to prevent SQL injection.
      whereArgs: [name],
    );
  }
  

  
}

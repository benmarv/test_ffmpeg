import 'package:link_on/screens/web3/token_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tokens.db');
    return _database!;
  }

  Future<Database> _initDB(String dbName) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = p.join(directory.path, dbName);
    return await openDatabase(path,
        version: 1, onCreate: _createDB, onUpgrade: _onUpgrade);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE tokens(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      networkName TEXT,
      networkRpcUrl TEXT,
      symbol TEXT,
      address TEXT UNIQUE,
      balance REAL
    )
  ''');
    await db.execute('CREATE INDEX idx_address ON tokens(address)');
  }

  Future<void> insertToken(TokenModel token) async {
    final db = await instance.database;
    await db.insert('tokens', token.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<TokenModel>> fetchTokensByNetwork(
      String selectedNetworkName) async {
    final db = await instance.database;
    final result = await db.query(
      'tokens',
      where: 'networkName = ?', // Filter by network name
      whereArgs: [
        selectedNetworkName
      ], // Pass the network name to filter tokens
    );
    return result.isNotEmpty
        ? result.map((e) => TokenModel.fromMap(e)).toList()
        : [];
  }

  Future<void> updateBalance(String tokenAddress, double newBalance) async {
    final db = await instance.database;

    // Update the token's balance based on its address
    int result = await db.update(
      'tokens',
      {'balance': newBalance}, // Set the new balance
      where: 'address = ?', // Where the token address matches
      whereArgs: [tokenAddress], // Token address to filter
    );

    if (result == 0) {
      // Handle if no rows were updated (could log or throw an error if needed)
      print('No token found with the address $tokenAddress');
    }
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // Check if 'networkName' column exists
      final result = await db.rawQuery('PRAGMA table_info(tokens)');
      final columnNames = result.map((e) => e['name'] as String).toList();
      if (!columnNames.contains('networkName')) {
        // Add 'networkName' column if it doesn't exist
        await db.execute('ALTER TABLE tokens ADD COLUMN networkName TEXT');
      }
    }
  }
}

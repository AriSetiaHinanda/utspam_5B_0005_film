import '../../models/transaction_model.dart';
import '../database_helper.dart';

class TransactionDao {
  final DatabaseHelper databaseHelper;

  TransactionDao(this.databaseHelper);

  Future<int> insertTransaction(Transaction transaction) async {
    final db = await databaseHelper.database;
    return await db.insert('transactions', transaction.toMap());
  }

  Future<List<Transaction>> getTransactionsByUserId(int userId) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return List.generate(maps.length, (i) {
      return Transaction.fromMap(maps[i]);
    });
  }

  Future<Transaction?> getTransactionById(int id) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Transaction.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateTransaction(Transaction transaction) async {
    final db = await databaseHelper.database;
    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<int> deleteTransaction(int id) async {
    final db = await databaseHelper.database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateTransactionStatus(int id, String status) async {
    final db = await databaseHelper.database;
    return await db.update(
      'transactions',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
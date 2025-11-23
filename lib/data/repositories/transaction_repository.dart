import '../models/transaction_model.dart';
import '../database/daos/transaction_dao.dart';
import '../database/database_helper.dart';

class TransactionRepository {
  final TransactionDao _transactionDao;

  TransactionRepository() : _transactionDao = TransactionDao(DatabaseHelper());

  Future<int> createTransaction(Transaction transaction) async {
    return await _transactionDao.insertTransaction(transaction);
  }

  Future<List<Transaction>> getTransactionsByUserId(int userId) async {
    return await _transactionDao.getTransactionsByUserId(userId);
  }

  Future<Transaction?> getTransactionById(int id) async {
    return await _transactionDao.getTransactionById(id);
  }

  Future<int> updateTransaction(Transaction transaction) async {
    return await _transactionDao.updateTransaction(transaction);
  }

  Future<int> cancelTransaction(int id) async {
    return await _transactionDao.updateTransactionStatus(id, 'cancelled');
  }

  Future<int> deleteTransaction(int id) async {
    return await _transactionDao.deleteTransaction(id);
  }
}
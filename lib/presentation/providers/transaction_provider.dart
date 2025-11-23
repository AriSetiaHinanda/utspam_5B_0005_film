import 'package:flutter/material.dart';
import '../../data/models/transaction_model.dart';
import '../../data/repositories/transaction_repository.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionRepository transactionRepository;
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  Transaction? _selectedTransaction;

  TransactionProvider({required this.transactionRepository});

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  Transaction? get selectedTransaction => _selectedTransaction;

  Future<bool> createTransaction(Transaction transaction) async {
    _isLoading = true;
    notifyListeners();

    try {
      final id = await transactionRepository.createTransaction(transaction);
      if (id > 0) {
        // Reload transactions
        await loadUserTransactions(transaction.userId);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> loadUserTransactions(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _transactions = await transactionRepository.getTransactionsByUserId(userId);
    } catch (e) {
      // Handle error
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Transaction?> getTransactionById(int id) async {
    try {
      return await transactionRepository.getTransactionById(id);
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateTransaction(Transaction transaction) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await transactionRepository.updateTransaction(transaction);
      if (result > 0) {
        // Reload transactions
        await loadUserTransactions(transaction.userId);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> cancelTransaction(int transactionId, int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await transactionRepository.cancelTransaction(transactionId);
      if (result > 0) {
        // Reload transactions
        await loadUserTransactions(userId);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void setSelectedTransaction(Transaction transaction) {
    _selectedTransaction = transaction;
    notifyListeners();
  }

  void clearSelectedTransaction() {
    _selectedTransaction = null;
    notifyListeners();
  }
}
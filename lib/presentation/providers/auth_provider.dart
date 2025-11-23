import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';

class AuthProvider with ChangeNotifier {
  final UserRepository userRepository;
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider({required this.userRepository});

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String identifier, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await userRepository.login(identifier, password);
      if (user != null) {
        _currentUser = user;
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

  Future<bool> register(User user) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Check if email already exists
      if (await userRepository.isEmailExists(user.email)) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Check if username already exists
      if (await userRepository.isUsernameExists(user.username)) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final id = await userRepository.registerUser(user);
      if (id > 0) {
        _currentUser = user.copyWith(id: id);
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

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  Future<void> loadUserProfile(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await userRepository.getUserById(userId);
      if (user != null) {
        _currentUser = user;
      }
    } catch (e) {
      // Handle error
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateProfile({
    required String username,
    required String fullName,
    required String email,
    required String address,
    required String phoneNumber,
  }) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedUser = _currentUser!.copyWith(
        username: username,
        fullName: fullName,
        email: email,
        address: address,
        phoneNumber: phoneNumber,
      );

      final success = await userRepository.updateUser(updatedUser);
      if (success) {
        _currentUser = updatedUser;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _errorMessage = 'Gagal memperbarui profil';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Verify old password
      final user = await userRepository.login(_currentUser!.username, oldPassword);
      if (user == null) {
        _errorMessage = 'Password lama tidak sesuai';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Update password
      final updatedUser = _currentUser!.copyWith(password: newPassword);
      final success = await userRepository.updateUser(updatedUser);
      if (success) {
        _currentUser = updatedUser;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _errorMessage = 'Gagal mengubah password';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
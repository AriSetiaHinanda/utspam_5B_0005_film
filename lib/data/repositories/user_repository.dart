import '../models/user_model.dart';
import '../database/daos/user_dao.dart';
import '../database/database_helper.dart';

class UserRepository {
  final UserDao _userDao;

  UserRepository() : _userDao = UserDao(DatabaseHelper());

  Future<int> registerUser(User user) async {
    return await _userDao.insertUser(user);
  }

  Future<User?> login(String identifier, String password) async {
    final user = await _userDao.getUserByEmailOrUsername(identifier);
    if (user != null && user.password == password) {
      return user;
    }
    return null;
  }

  Future<bool> isEmailExists(String email) async {
    return await _userDao.checkEmailExists(email);
  }

  Future<bool> isUsernameExists(String username) async {
    return await _userDao.checkUsernameExists(username);
  }

  Future<User?> getUserById(int id) async {
    return await _userDao.getUserById(id);
  }

  Future<bool> updateUser(User user) async {
    final result = await _userDao.updateUser(user);
    return result > 0;
  }
}
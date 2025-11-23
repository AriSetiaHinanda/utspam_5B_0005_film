import '../../models/film_model.dart';
import '../../models/schedule_model.dart';
import '../database_helper.dart';

class FilmDao {
  final DatabaseHelper databaseHelper;

  FilmDao(this.databaseHelper);

  Future<List<Film>> getAllFilms() async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('films');
    return List.generate(maps.length, (i) {
      return Film.fromMap(maps[i]);
    });
  }

  Future<Film?> getFilmById(int id) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'films',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Film.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Schedule>> getSchedulesByFilmId(int filmId) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'schedules',
      where: 'film_id = ?',
      whereArgs: [filmId],
    );
    return List.generate(maps.length, (i) {
      return Schedule.fromMap(maps[i]);
    });
  }

  Future<Schedule?> getScheduleById(int scheduleId) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'schedules',
      where: 'id = ?',
      whereArgs: [scheduleId],
    );
    if (maps.isNotEmpty) {
      return Schedule.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateAvailableSeats(int scheduleId, int newSeatCount) async {
    final db = await databaseHelper.database;
    return await db.update(
      'schedules',
      {'available_seats': newSeatCount},
      where: 'id = ?',
      whereArgs: [scheduleId],
    );
  }
}
import '../models/film_model.dart';
import '../models/schedule_model.dart';
import '../database/daos/film_dao.dart';
import '../database/database_helper.dart';

class FilmRepository {
  final FilmDao _filmDao;

  FilmRepository() : _filmDao = FilmDao(DatabaseHelper());

  Future<List<Film>> getAllFilms() async {
    return await _filmDao.getAllFilms();
  }

  Future<Film?> getFilmById(int id) async {
    return await _filmDao.getFilmById(id);
  }

  Future<List<Schedule>> getSchedulesByFilmId(int filmId) async {
    return await _filmDao.getSchedulesByFilmId(filmId);
  }

  Future<Schedule?> getScheduleById(int scheduleId) async {
    return await _filmDao.getScheduleById(scheduleId);
  }

  Future<int> updateAvailableSeats(int scheduleId, int newSeatCount) async {
    return await _filmDao.updateAvailableSeats(scheduleId, newSeatCount);
  }
}
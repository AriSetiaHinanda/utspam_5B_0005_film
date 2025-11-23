import 'package:flutter/material.dart';
import '../../data/models/film_model.dart';
import '../../data/models/schedule_model.dart';
import '../../data/repositories/film_repository.dart';

class FilmProvider with ChangeNotifier {
  final FilmRepository filmRepository;
  List<Film> _films = [];
  List<Schedule> _schedules = [];
  bool _isLoading = false;
  Film? _selectedFilm;

  FilmProvider({required this.filmRepository});

  List<Film> get films => _films;
  List<Schedule> get schedules => _schedules;
  bool get isLoading => _isLoading;
  Film? get selectedFilm => _selectedFilm;

  Future<void> loadAllFilms() async {
    _isLoading = true;
    notifyListeners();

    try {
      _films = await filmRepository.getAllFilms();
    } catch (e) {
      // Handle error
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadFilmSchedules(int filmId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _schedules = await filmRepository.getSchedulesByFilmId(filmId);
      _selectedFilm = await filmRepository.getFilmById(filmId);
    } catch (e) {
      // Handle error
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Film?> getFilmById(int filmId) async {
    try {
      return await filmRepository.getFilmById(filmId);
    } catch (e) {
      return null;
    }
  }

  Future<Schedule?> getScheduleById(int scheduleId) async {
    try {
      return await filmRepository.getScheduleById(scheduleId);
    } catch (e) {
      return null;
    }
  }

  void setSelectedFilm(Film film) {
    _selectedFilm = film;
    notifyListeners();
  }

  void clearSelectedFilm() {
    _selectedFilm = null;
    notifyListeners();
  }
}
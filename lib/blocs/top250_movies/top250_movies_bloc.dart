import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/movie.dart';
import '../../models/movies.dart';
import '../../repositories/movies_repository.dart';
import 'top250_movies_event.dart';
import 'top250_movies_state.dart';

class Top250MoviesBloc extends Bloc<Top250MoviesEvent, Top250MoviesState> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final MoviesRepository moviesRepository;
  num _currentPage = 0;
  late Movies _movies;

  Top250MoviesBloc({
    required this.moviesRepository,
  }) : super(const InitialState()) {
    on<Top250MoviesFetchFirstEvent>((event, emit) async {
      final SharedPreferences prefs = await _prefs;
      String data = prefs.getString('data') ?? "";
      if (data.isEmpty) {
        _currentPage = 1;
        _movies = await moviesRepository.getMovies(page: _currentPage);
        data = jsonEncode(_movies.toJson());
        prefs.setString('data', data);
        emit.call(Top250MoviesSuccessState(data: _movies));
      } else {
        _movies = Movies.fromJson(jsonDecode(data));
        emit.call(Top250MoviesSuccessState(data: _movies));
        
        _movies = await moviesRepository.getMovies(page: 1);
        emit.call(Top250MoviesSuccessState(data: _movies));
      }

      

      
    });
    on<Top250MoviesFetchNextEvent>((event, emit) async {
      _currentPage++;

      var movies = await moviesRepository.getMovies(page: _currentPage);
      _movies.results?.addAll(
          movies.results != null ? movies.results! : List<Movie>.empty());
      emit.call(Top250MoviesSuccessState(data: _movies));
    });
  }
}

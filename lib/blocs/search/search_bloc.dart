import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/person.dart';
import '../../models/movie.dart';
import '../../models/movies.dart';
import '../../models/people.dart';
import '../../repositories/movies_repository.dart';
import '../../repositories/people_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MoviesRepository moviesRepository;
  final PeopleRepository peopleRepository;
  String _lastQuery = "";
  num _currentPage = 0;
  late Movies _movies;
  late People _people;

  SearchBloc({
    required this.moviesRepository,
    required this.peopleRepository,
  }) : super(const InitialState()) {
    on<MoviesSearchEvent>((event, emit) async {
      _lastQuery = event.query;
      _currentPage = 1;

      _movies = await moviesRepository.findMovies(
          page: _currentPage, query: event.query);
      emit.call(SearchMoviesSuccessState(data: _movies));
    });
    on<PeopleSearchEvent>((event, emit) async {
      _lastQuery = event.query;
      _currentPage = 1;

      _people = await peopleRepository.findPeople(
          page: _currentPage, query: event.query);
      emit.call(SearchPeopleSuccessState(data: _people));
    });
    on<MoviesFetchNextEvent>((event, emit) async {
      _currentPage++;

      var movies = await moviesRepository.findMovies(
          page: _currentPage, query: _lastQuery);
      _movies.results?.addAll(
          movies.results != null ? movies.results! : List<Movie>.empty());
      emit.call(SearchMoviesSuccessState(data: _movies));
    });
    on<PeopleFetchNextEvent>((event, emit) async {
      _currentPage++;

      var people = await peopleRepository.findPeople(
          page: _currentPage, query: _lastQuery);
      _people.results?.addAll(
          people.results != null ? people.results! : List<Person>.empty());
      emit.call(SearchPeopleSuccessState(data: _people));
    });
    on<MoviesClearEvent>((event, emit) async {
      _lastQuery = "";
      _currentPage = 1;
      emit.call(SearchMoviesSuccessState(data: Movies()));
    });
    on<PeopleClearEvent>((event, emit) async {
      _lastQuery = "";
      _currentPage = 1;
      emit.call(SearchPeopleSuccessState(data: People()));
    });
  }
}

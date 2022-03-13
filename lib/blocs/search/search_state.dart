import '../../models/movies.dart';

import '../../models/people.dart';

abstract class SearchState {
  const SearchState();
}

class InitialState extends SearchState {

  const InitialState();
}

class LoadingState extends SearchState {
  final String message;

  const LoadingState({
    required this.message,
  });
}
class SearchMoviesSuccessState extends SearchState {
  final Movies data;

  const SearchMoviesSuccessState({
    required this.data,
  });
}

class SearchPeopleSuccessState extends SearchState {
  final People data;

  const SearchPeopleSuccessState({
    required this.data,
  });
}
class ErrorState extends SearchState {
  final String error;

  const ErrorState({
    required this.error,
  });
}




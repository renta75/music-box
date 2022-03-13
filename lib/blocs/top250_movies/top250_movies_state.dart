import '../../models/movies.dart';


abstract class Top250MoviesState {
  const Top250MoviesState();
}

class InitialState extends Top250MoviesState {

  const InitialState();
}

class LoadingState extends Top250MoviesState {
  final String message;

  const LoadingState({
    required this.message,
  });
}
class Top250MoviesSuccessState extends Top250MoviesState {
  final Movies data;

  const Top250MoviesSuccessState({
    required this.data,
  });
}

class ErrorState extends Top250MoviesState {
  final String error;

  const ErrorState({
    required this.error,
  });
}




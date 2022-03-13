import '../../models/movie_credit.dart';

abstract class PersonDetailsState {
  const PersonDetailsState();
}

class InitialState extends PersonDetailsState {
  const InitialState();
}

class LoadingState extends PersonDetailsState {
  final String message;

  const LoadingState({
    required this.message,
  });
}

class PersonDetailsSuccessState extends PersonDetailsState {
  final List<MovieCredit> movieCredits;

  const PersonDetailsSuccessState({
    required this.movieCredits
  });
}

class ErrorState extends PersonDetailsState {
  final String error;

  const ErrorState({
    required this.error,
  });
}

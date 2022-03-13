import '../../models/actor.dart';
import '../../models/reviews.dart';

abstract class MovieDetailsState {
  const MovieDetailsState();
}

class InitialState extends MovieDetailsState {
  const InitialState();
}

class LoadingState extends MovieDetailsState {
  final String message;

  const LoadingState({
    required this.message,
  });
}

class MovieDetailsSuccessState extends MovieDetailsState {
  final Reviews reviews;
  final List<Actor> people;

  const MovieDetailsSuccessState({required this.reviews, required this.people });
}

class ErrorState extends MovieDetailsState {
  final String error;

  const ErrorState({
    required this.error,
  });
}

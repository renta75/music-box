abstract class MovieDetailsEvent {
  const MovieDetailsEvent();
}

class MovieDetailsFetchEvent extends MovieDetailsEvent {
  final num movieId;
  const MovieDetailsFetchEvent({required this.movieId});
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/movies_repository.dart';
import 'movie_details_event.dart';
import 'movie_details_state.dart';


class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final MoviesRepository moviesRepository;

  MovieDetailsBloc({
    required this.moviesRepository,
  }) : super(const InitialState()) {
    on<MovieDetailsFetchEvent>((event, emit) async {
      
      emit.call(MovieDetailsSuccessState( people: (await moviesRepository.getPersonsForMovie (
          movieId: event.movieId)).take(5).toList(), reviews: await moviesRepository.getReviewsForMovie (
          movieId: event.movieId)));
    });

  }
}

import '../models/movie_credit.dart';
import '../models/people.dart';
import '../api/tmdb.dart';

class PeopleRepository {
  static final PeopleRepository _peopleRepository = PeopleRepository._();
  static const num _perPage = 20;

  PeopleRepository._();

  factory PeopleRepository() {
    return _peopleRepository;
  }

  Future<People> findPeople({
    required num page,
    required String query,
  }) async {
    return await TMDB().findPeople(page, _perPage, query);
  }

  Future<List<MovieCredit>> getMoviesForPerson({
    required num personId,
  }) async {
    return await TMDB().getMoviesByActor(personId);
  }
}

abstract class SearchEvent {
  const SearchEvent();
}

class MoviesSearchEvent extends SearchEvent {
  final String query;

  const MoviesSearchEvent(this.query);

  @override
  String toString() => 'MoviesSearchEvent { query: $query }';
}

class PeopleSearchEvent extends SearchEvent {
  final String query;

  const PeopleSearchEvent(this.query);

  @override
  String toString() => 'PeopleSearchEvent { query: $query }';
}

class MoviesFetchNextEvent extends SearchEvent {
  const MoviesFetchNextEvent();
}

class PeopleFetchNextEvent extends SearchEvent {
  const PeopleFetchNextEvent();
}

class MoviesClearEvent extends SearchEvent {
  const MoviesClearEvent();
}

class PeopleClearEvent extends SearchEvent {
  const PeopleClearEvent();
}

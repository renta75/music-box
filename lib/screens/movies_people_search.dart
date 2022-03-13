import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/search/search_bloc.dart';
import '../blocs/search/search_event.dart';
import '../blocs/search/search_state.dart';
import '../widgets/movie_list_tile.dart';
import '../widgets/people_list_tile.dart';

class MoviesPeopleSearch extends StatefulWidget {
  const MoviesPeopleSearch({Key? key}) : super(key: key);

  @override
  State<MoviesPeopleSearch> createState() => _MoviesPeopleSearchState();
}

class _MoviesPeopleSearchState extends State<MoviesPeopleSearch> {
  final ScrollController _scrollControllerMovies = ScrollController();
  final ScrollController _scrollControllerPeople = ScrollController();
  late SearchBloc searchBloc;

  @override
  void initState() {
    super.initState();
    _onScrollMovies(context);
    _onScrollPeople(context);
  }

  @override
  Widget build(BuildContext context) {
    searchBloc = BlocProvider.of<SearchBloc>(context);

    return BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
      if (state is InitialState) {
        return const Material();
      } else if (state is SearchMoviesSuccessState) {
        return GridView.builder(
            controller: _scrollControllerMovies,
            physics: const ScrollPhysics(),
            padding: const EdgeInsets.all(5.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.15,
            ),
            itemCount: state.data.results!.length,
            itemBuilder: (context, index) =>
                MovieListViewTile(movie: state.data.results![index]));
      } else if (state is SearchPeopleSuccessState) {
        return GridView.builder(
            controller: _scrollControllerPeople,
            physics: const ScrollPhysics(),
            padding: const EdgeInsets.all(10.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
            ),
            itemCount: state.data.results!.length,
            itemBuilder: (context, index) =>
                PeopleListViewTile(person:state.data.results![index]));
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }

  void _onScrollMovies(context) async {
    _scrollControllerMovies.addListener(() {
      if (_scrollControllerMovies.position.atEdge) {
        if (_scrollControllerMovies.position.pixels != 0) {
          searchBloc.add(const MoviesFetchNextEvent());
        }
      }
    });
  }

  void _onScrollPeople(context) async {
    _scrollControllerPeople.addListener(() {
      if (_scrollControllerPeople.position.atEdge) {
        if (_scrollControllerPeople.position.pixels != 0) {
          searchBloc.add(const PeopleFetchNextEvent());
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollControllerMovies.dispose();
    _scrollControllerPeople.dispose();
    super.dispose();
  }
}

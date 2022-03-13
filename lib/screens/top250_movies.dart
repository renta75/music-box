import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/top250_movies/top250_movies_bloc.dart';
import '../blocs/top250_movies/top250_movies_event.dart';
import '../blocs/top250_movies/top250_movies_state.dart';
import '../widgets/movie_list_tile.dart';

class Top250Movies extends StatefulWidget {
  const Top250Movies({Key? key}) : super(key: key);


  @override
  State<Top250Movies> createState() => _Top250MoviesState();
}

class _Top250MoviesState extends State<Top250Movies> {
  final ScrollController _scrollController = ScrollController();
  
  late Top250MoviesBloc top250MoviesBloc;

  @override
  void initState() {
    super.initState();
    _onScroll(context);
  }
 
  @override
  Widget build(BuildContext context) {
    top250MoviesBloc = BlocProvider.of<Top250MoviesBloc>(context);

    return BlocBuilder<Top250MoviesBloc, Top250MoviesState>(builder: (context, state) {
      if (state is InitialState) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is Top250MoviesSuccessState) {
        return GridView.builder(
            controller: _scrollController,
            physics: const ScrollPhysics(),
            padding: const EdgeInsets.all(5.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.15,
            ),
            itemCount: state.data.results!.length,
            itemBuilder: (context, index) =>
                MovieListViewTile(movie: state.data.results![index]));
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }

  void _onScroll(context) async {
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          top250MoviesBloc.add(const Top250MoviesFetchNextEvent());
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
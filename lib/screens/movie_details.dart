import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/movie_details/movie_details_bloc.dart';
import '../blocs/movie_details/movie_details_event.dart';
import '../blocs/movie_details/movie_details_state.dart';

import 'review_details.dart';
import '../global/colors.dart';
import '../models/movie.dart';
import '../repositories/movies_repository.dart';
import '../widgets/actor_list_tile.dart';

class MovieDetails extends StatelessWidget {
  const MovieDetails({Key? key, required this.movie}) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          Expanded(
              child: Container(
                  alignment: Alignment.center,
                  child: const Text("Movie Details")))
        ]),
        body: MultiBlocProvider(
            providers: [
              BlocProvider<MovieDetailsBloc>(
                  create: (context) =>
                      MovieDetailsBloc(moviesRepository: MoviesRepository())
                        ..add(MovieDetailsFetchEvent(movieId: movie.id!)))
            ],
            child: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
                builder: (context, state) {
              if (state is InitialState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is MovieDetailsSuccessState) {
                return Flex(direction: Axis.vertical, children: [
                  _DetailedInfo(movie),
                  Expanded(
                      child: Material(
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              primary: true,
                              itemCount: state.people.length,
                              itemBuilder: (BuildContext context, index) {
                                return ActorListViewTile(
                                    actor: state.people[index]);
                              }))),
                  Expanded(
                      child: Material(
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              primary: true,
                              itemCount: state.reviews.results != null
                                  ? state.reviews.results!.length
                                  : 0,
                              itemBuilder: (BuildContext context, index) {
                                return Container(
                                    padding: const EdgeInsets.all(5),
                                    width: 200,
                                    child: InkWell(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ReviewDialog(
                                                      review: state.reviews
                                                          .results![index]),
                                            )),
                                        child: Card(
                                          child: Column(
                                            children: [
                                              Container(
                                                  child: Text(
                                                    state
                                                        .reviews
                                                        .results![index]
                                                        .author!,
                                                    style: const TextStyle(
                                                        color: Colors.blue,
                                                        fontSize: 15),
                                                  ),
                                                  alignment:
                                                      Alignment.centerLeft),
                                              Text(
                                                state.reviews.results![index]
                                                    .content!,
                                                maxLines: 7,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          color: colorBlackGradient92,
                                        )));
                              })))
                ]);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            })));
  }
}

class _DetailedInfo extends StatelessWidget {
  const _DetailedInfo(this.movie);
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final isImageBroken = movie.backdropPath ?? movie.posterPath;

    Widget image = isImageBroken != null
        ? CachedNetworkImage(
            progressIndicatorBuilder: (context, url, progress) => Center(
              child: CircularProgressIndicator(
                value: progress.progress,
              ),
            ),
            imageUrl: Uri.https("image.tmdb.org", "/t/p/w500" + isImageBroken)
                .toString(),
            fit: BoxFit.cover,
          )
        : const Image(image: AssetImage("assets/images/video_placeholder.jpg"));

    return Container(
      margin: const EdgeInsets.all(2.0),
      child: Card(
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: colorBlackGradient92,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 16.0 / 9.0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0)),
                  child: image,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        movie.title!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: colorBlack, fontWeight: FontWeight.w600),
                      ),
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, top: 5.0, bottom: 5.0, right: 15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.star,
                        size: 16.0,
                        color: colorDarkYellow,
                      ),
                      Text(
                        movie.voteAverage.toString(),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 3.0),
                        child: Icon(
                          Icons.event_note,
                          size: 16.0,
                          color: colorBlack,
                        ),
                      ),
                      Text(
                        movie.releaseDate!,
                      ),
                    ],
                  )),
            ],
          )),
    );
  }
}

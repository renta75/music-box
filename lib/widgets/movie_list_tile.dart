import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../global/colors.dart';
import '../models/movie.dart';
import '../screens/movie_details.dart';

class MovieListViewTile extends StatelessWidget {
  const MovieListViewTile({Key? key,required this.movie}) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 1.0),
          child: Row(
            children: <Widget>[_DetailedInfo(movie:movie)],
          ),
        )
      ],
    );
  }
}

class _DetailedInfo extends StatelessWidget {
  const _DetailedInfo({Key? key,required this.movie}) : super(key: key);
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final isImageBroken =
        movie.backdropPath ?? movie.posterPath;

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

    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(2.0),
        child: InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetails(movie:movie),
              )),
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
                            movie.releaseDate?? '0000/00/00',
                          ),
                        ],
                      )),
                ],
              )),
        ),
      ),
    );
  }
}

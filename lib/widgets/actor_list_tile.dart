import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../global/colors.dart';
import '../models/actor.dart';

class ActorListViewTile extends StatelessWidget {
  const ActorListViewTile({Key? key, required this.actor}) : super(key: key);

  final Actor actor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 1.0),
          child: Row(
            children: <Widget>[_DetailedInfo(actor: actor)],
          ),
        )
      ],
    );
  }
}

class _DetailedInfo extends StatelessWidget {
  const _DetailedInfo({required this.actor});
  final Actor actor;

  @override
  Widget build(BuildContext context) {
    Widget image = actor.profilePath != null
        ? CachedNetworkImage(
            progressIndicatorBuilder: (context, url, progress) => Center(
              child: CircularProgressIndicator(
                value: progress.progress,
              ),
            ),
            imageUrl:
                Uri.https("image.tmdb.org", "/t/p/w500" + actor.profilePath!)
                    .toString(),
            fit: BoxFit.cover,
          )
        : const Image(image: AssetImage("assets/images/actor_placeholder.jpg"));

    return Container(
      width: 110,
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
              aspectRatio: 5.0 / 5.0,
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
                      actor.name!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: colorBlack, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      actor.character.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

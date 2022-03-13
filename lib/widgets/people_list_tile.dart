import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../screens/person_details.dart';

import '../global/colors.dart';
import '../models/person.dart';

class PeopleListViewTile extends StatelessWidget {
  const PeopleListViewTile({Key? key, required this.person}) : super(key: key);

  final Person person;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 1.0),
          child: Row(
            children: <Widget>[_DetailedInfo(person: person)],
          ),
        )
      ],
    );
  }
}

class _DetailedInfo extends StatelessWidget {
  const _DetailedInfo({required this.person});
  final Person person;

  @override
  Widget build(BuildContext context) {
    Widget image = person.profilePath != null
        ? CachedNetworkImage(
            progressIndicatorBuilder: (context, url, progress) => Center(
              child: CircularProgressIndicator(
                value: progress.progress,
              ),
            ),
            imageUrl:
                Uri.https("image.tmdb.org", "/t/p/w500" + person.profilePath!)
                    .toString(),
            fit: BoxFit.cover,
          )
        : const Image(image: AssetImage("assets/images/actor_placeholder.jpg"));

    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(2.0),
        child: InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PersonDetails(person: person),
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
                            person.name!,
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
                            person.popularity.toString(),
                          )
                        ],
                      )),
                ],
              )),
        ),
      ),
    );
  }
}

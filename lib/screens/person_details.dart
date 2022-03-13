import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/person.dart';
import '../blocs/person_details/person_details_bloc.dart';
import '../blocs/person_details/person_details_event.dart';
import '../blocs/person_details/person_details_state.dart';
import '../global/colors.dart';
import '../repositories/people_repository.dart';
import '../widgets/movie_credit_list_tile.dart';

class PersonDetails extends StatelessWidget {
  const PersonDetails({Key? key, required this.person}) : super(key: key);

  final Person person;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          Expanded(
              child: Container(
                  alignment: Alignment.center,
                  child: const Text("Actor Details")))
        ]),
        body: MultiBlocProvider(
            providers: [
              BlocProvider<PersonDetailsBloc>(
                  create: (context) =>
                      PersonDetailsBloc(peopleRepository: PeopleRepository())
                        ..add(PersonDetailsFetchEvent(personId: person.id!)))
            ],
            child: BlocBuilder<PersonDetailsBloc, PersonDetailsState>(
                builder: (context, state) {
              if (state is InitialState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PersonDetailsSuccessState) {
                return Flex(direction: Axis.vertical, children: [
                  _DetailedInfo(person: person),
                  Expanded(
                      child: Material(
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              primary: true,
                              itemCount: state.movieCredits.length,
                              itemBuilder: (BuildContext context, index) {
                                return MovieCreditCreditListViewTile(
                                    moviecredit: state.movieCredits[index]);
                              }))),
                ]);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            })));
  }
}

class _DetailedInfo extends StatelessWidget {
  const _DetailedInfo({Key? key, required this.person}) : super(key: key);
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
            ],
          )),
    );
  }
}

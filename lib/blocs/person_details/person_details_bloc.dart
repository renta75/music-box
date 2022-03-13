import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/people_repository.dart';
import 'person_details_event.dart';
import 'person_details_state.dart';


class PersonDetailsBloc extends Bloc<PersonDetailsEvent, PersonDetailsState> {
  final PeopleRepository peopleRepository;

  PersonDetailsBloc({
    required this.peopleRepository,
  }) : super(const InitialState()) {
    on<PersonDetailsFetchEvent>((event, emit) async {
      
      emit.call(PersonDetailsSuccessState( movieCredits: (await peopleRepository.getMoviesForPerson (
          personId: event.personId)).take(5).toList()));
    });

  }
}

abstract class PersonDetailsEvent {
  const PersonDetailsEvent();
}

class PersonDetailsFetchEvent extends PersonDetailsEvent {
  final num personId;
  const PersonDetailsFetchEvent({required this.personId});
}

abstract class MusicLibraryEvent {
  const MusicLibraryEvent();
}

class MusicLibraryFetchEvent extends MusicLibraryEvent {
  const MusicLibraryFetchEvent();
}
class MusicLibraryPlayEvent extends MusicLibraryEvent {
  const MusicLibraryPlayEvent({required this.filename});
  final String filename;
}

class MusicLibraryStopEvent extends MusicLibraryEvent {
  const MusicLibraryStopEvent();
}
class MusicLibraryBorrowEvent extends MusicLibraryEvent {
  final int id;
  const MusicLibraryBorrowEvent({required this.id});
}

class MusicLibraryReturnEvent extends MusicLibraryEvent {
  final int id;
  const MusicLibraryReturnEvent({required this.id});
}
import 'package:tmdb/models/music_track.dart';

abstract class MusicLibraryState {
  const MusicLibraryState();
}

class InitialState extends MusicLibraryState {
  const InitialState();
}

class MusicLibraryLoadingState extends MusicLibraryState {
  final String message;

  const MusicLibraryLoadingState({
    required this.message,
  });
}

class MusicLibrarySuccessState extends MusicLibraryState {
  final List<MusicTrack> library;
  final List<MusicTrack> borrowed;

  const MusicLibrarySuccessState({
    required this.library,
    required this.borrowed
  });
}

class MusicLibraryBorrowedSuccessState extends MusicLibraryState {
  final List<MusicTrack> data;

  const MusicLibraryBorrowedSuccessState({
    required this.data,
  });
}

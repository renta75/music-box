import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb/models/music_track.dart';
import 'package:tmdb/repositories/music_tracks_repository.dart';

import 'music_library_event.dart';
import 'music_library_state.dart';

class MusicLibraryBloc extends Bloc<MusicLibraryEvent, MusicLibraryState> {
  late List<MusicTrack> _tracks;

  final MusicTracksRepository musicTracksRepository;
  final AudioPlayer audioPlayer = AudioPlayer();

  MusicLibraryBloc({
    required this.musicTracksRepository,
  }) : super(const InitialState()) {
    on<MusicLibraryFetchEvent>((event, emit) async {
      emit.call(const MusicLibraryLoadingState(message: "Loading"));
      _tracks = await musicTracksRepository.getMusicTracks(page: 1);
      List<MusicTrack> tracks=List.empty();
      try {
        tracks = await musicTracksRepository.getBorrowedTracks(page: 1);
      } catch (exc) {
        tracks = List.empty();
      }

      emit.call(MusicLibrarySuccessState(library: _tracks, borrowed: tracks));
    });
    on<MusicLibraryPlayEvent>((event, emit) async {
      audioPlayer.stop();
      audioPlayer.release();
      audioPlayer.play("https://matrixcode.hr:7500/media/" + event.filename);
      _tracks = await musicTracksRepository.getMusicTracks(page: 1);
      var tracks = await musicTracksRepository.getBorrowedTracks(page: 1);
      emit.call(MusicLibrarySuccessState(library: _tracks, borrowed: tracks));
    });
    on<MusicLibraryBorrowEvent>((event, emit) async {
      await musicTracksRepository.borrowMusicTracks(id: event.id);

      emit.call(MusicLibrarySuccessState(
          library: await musicTracksRepository.getMusicTracks(page: 1),
          borrowed: await musicTracksRepository.getBorrowedTracks(page: 1)));
    });
    on<MusicLibraryReturnEvent>((event, emit) async {
      await musicTracksRepository.returnMusicTracks(id: event.id);
      emit.call(MusicLibrarySuccessState(
          library: await musicTracksRepository.getMusicTracks(page: 1),
          borrowed: await musicTracksRepository.getBorrowedTracks(page: 1)));
    });
  }
}

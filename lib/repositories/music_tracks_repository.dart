import 'package:tmdb/api/musicbox.dart';
import 'package:tmdb/models/music_track.dart';

class MusicTracksRepository {
  static final MusicTracksRepository _musicTracksRepository =
      MusicTracksRepository._();
  static const num _perPage = 20;

  MusicTracksRepository._();

  factory MusicTracksRepository() {
    return _musicTracksRepository;
  }

  Future<List<MusicTrack>> getMusicTracks({
    required num page,
  }) async {
    return await MusicBox().getMusicTracks(page, _perPage);
  }

  Future<List<MusicTrack>> getBorrowedTracks({
    required num page,
  }) async {
    return await MusicBox().getBorrowedTracks(page, _perPage);
  }

  Future<void> borrowMusicTracks({
    required int id,
  }) async {
    return await MusicBox().borrowMusicTracks(id);
  }

  Future<void> returnMusicTracks({
    required int id,
  }) async {
    return await MusicBox().returnMusicTracks(id);
  }
}

import 'package:dio/dio.dart';
import 'package:tmdb/models/music_track.dart';
import 'package:tmdb/utils/auth_settings.dart';

class MusicBox {
  final Dio _dio = Dio();
  static const String baseURL = "https://matrixcode.hr:7500/api";

  Future<List<MusicTrack>> getMusicTracks(num page, num perPage) async {
    String url = "/musictracks";

    Response response = await _dio.get(baseURL + url,
        options: Options(
            headers: {'Authorization': 'Bearer ${AuthSettings.getToken()}'}));
    var apidata = response.data;

    return apidata["items"]
        .map((item) => MusicTrack.fromJson(item))
        .toList()
        .cast<MusicTrack>();
  }

  Future<List<MusicTrack>> getBorrowedTracks(num page, num perPage) async {
    String url = "/musictracks/borrowed";

    Response response = await _dio.get(baseURL + url,
        queryParameters: {"UserName": await AuthSettings.localStorage.getUserName()},
        options: Options(
            headers: {'Authorization': 'Bearer ${AuthSettings.getToken()}'}));
    var apidata = response.data;

    return apidata["items"]
        .map((item) => MusicTrack.fromJson(item))
        .toList()
        .cast<MusicTrack>();
  }

  Future<void> borrowMusicTracks(int id) async {
    String url = "/musictracks/borrow";
    print("borrowMusicTracks_pre");
    await _dio.post(baseURL + url,
        data: {"UserName": await AuthSettings.localStorage.getUserName(), "Id": id},
        options: Options(
            headers: {'Authorization': 'Bearer ${AuthSettings.getToken()}'}));
    print("borrowMusicTracks_post");

    return;
  }

  Future<void> returnMusicTracks(int id) async {
    String url = "/musictracks/return";

    await _dio.post(baseURL + url,
        data: {"UserName": await AuthSettings.localStorage.getUserName(), "Id": id},
        options: Options(
            headers: {'Authorization': 'Bearer ${AuthSettings.getToken()}'}));

    return;
  }
}

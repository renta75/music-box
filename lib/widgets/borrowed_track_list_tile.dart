import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb/blocs/music_library/music_library_bloc.dart';
import 'package:tmdb/models/music_track.dart';
import 'package:video_player/video_player.dart';

import 'borrowed_track_dialog.dart';

class BorrowedTrackListViewTile extends StatelessWidget {
  const BorrowedTrackListViewTile({Key? key, required this.track})
      : super(key: key);

  final MusicTrack track;

  @override
  Widget build(BuildContext context) {
    return _DetailedInfo(track: track);
  }
}

class _DetailedInfo extends StatelessWidget {
  const _DetailedInfo({Key? key, required this.track}) : super(key: key);
  final MusicTrack track;

  @override
  Widget build(BuildContext context) {

    Widget image = CachedNetworkImage(
      progressIndicatorBuilder: (context, url, progress) => Center(
        child: CircularProgressIndicator(
          value: progress.progress,
        ),
      ),
      imageUrl:
          Uri.https("matrixcode.hr:7500", "/picture/" + track.coverPicture!)
              .toString(),
      fit: BoxFit.cover,
      memCacheHeight: 400
    );
    var musicLibraryBloc = BlocProvider.of<MusicLibraryBloc>(context);
              
    return Container(
        margin: const EdgeInsets.all(2.0),
        child: InkWell(
          onTap: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return BorrowedTrackDialog(track: track,bloc: musicLibraryBloc);
              }),
          child: Card(
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1.00,
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
                            track.title!,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ],
                      )),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, top: 5.0, bottom: 5.0, right: 15.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding: const EdgeInsets.only(right: 3.0),
                            child: Icon(
                              Icons.person,
                              size: 16.0,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            track.performer!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ],
                      )),
                ],
              )),
        ),
    );
  }
}

class VideoApp extends StatefulWidget {
  const VideoApp({Key? key, required this.track}) : super(key: key);
  final MusicTrack track;

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        "https://matrixcode.hr:7500/media/" + widget.track.fileName!)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

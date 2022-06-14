import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:tmdb/blocs/music_library/music_library_bloc.dart';
import 'package:tmdb/blocs/music_library/music_library_state.dart';
import 'package:tmdb/widgets/borrowed_track_list_tile.dart';
import 'package:tmdb/widgets/music_track_list_tile.dart';

class MusicLibraryBorrowed extends StatefulWidget {
  const MusicLibraryBorrowed({Key? key}) : super(key: key);

  @override
  State<MusicLibraryBorrowed> createState() => _MusicLibraryBorrowedState();
}

class _MusicLibraryBorrowedState extends State<MusicLibraryBorrowed> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicLibraryBloc, MusicLibraryState>(
        builder: (context, state) {
      if (state is InitialState) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is MusicLibrarySuccessState) {
        return ResponsiveGridList(
            horizontalGridMargin: 50,
            verticalGridMargin: 50,
            minItemWidth: 200,
            children: state.borrowed.map((track) {
              return BorrowedTrackListViewTile(track: track);
            }).toList());
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }
}

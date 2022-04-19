import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb/blocs/music_library/music_library_bloc.dart';
import 'package:tmdb/blocs/music_library/music_library_event.dart';
import 'package:tmdb/repositories/music_tracks_repository.dart';
import 'package:tmdb/screens/music_library.dart';
import 'package:tmdb/screens/music_library_borrowed.dart';
import 'package:tmdb/utils/auth_settings.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<CollapsibleItem> _items;
  late String _headline;
  late String _username;

  @override
  void initState() {
    super.initState();
    _items = _generateItems;
    _headline = _items.firstWhere((item) => item.isSelected).text;
    AuthSettings.localStorage.getUserName().then((value) => _username = value!);
  }

  List<CollapsibleItem> get _generateItems {
    return [
      CollapsibleItem(
          text: 'Home',
          icon: Icons.home,
          onPressed: () => setState(() => _headline = 'Home'),
          isSelected: true),
      CollapsibleItem(
        text: 'Search',
        icon: Icons.search,
        onPressed: () => setState(() => _headline = 'Search'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Material(
        type: MaterialType.transparency,
        child: SafeArea(
            child: CollapsibleSidebar(
          isCollapsed: true,
          items: _items,
          title: _username,
          onTitleTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Yay! Flutter Collapsible Sidebar!')));
          },
          body: _body(size, context),
          backgroundColor: Colors.black,
          selectedTextColor: Colors.greenAccent,
          textStyle: TextStyle(fontSize: 15),
          titleStyle: TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
          toggleTitleStyle:
              TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          sidebarBoxShadow: [
            BoxShadow(
              color: Colors.indigo,
              blurRadius: 20,
              spreadRadius: 0.01,
              offset: Offset(3, 3),
            ),
            BoxShadow(
              color: Colors.green,
              blurRadius: 50,
              spreadRadius: 0.01,
              offset: Offset(3, 3),
            ),
          ],
        )));
  }

  Widget _body(Size size, BuildContext context) {
    return Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.blueGrey[50],
        child: _headline == "Home"
            ? const MusicLibrary()
            : const MusicLibraryBorrowed());
  }
}

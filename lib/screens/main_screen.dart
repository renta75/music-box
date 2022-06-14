import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb/blocs/authentication_cubit/authentication_cubit.dart';
import 'package:tmdb/blocs/music_library/music_library_bloc.dart';
import 'package:tmdb/blocs/music_library/music_library_event.dart';
import 'package:tmdb/repositories/accounts_repository.dart';
import 'package:tmdb/repositories/authentication_repository.dart';
import 'package:tmdb/repositories/music_tracks_repository.dart';
import 'package:tmdb/screens/login_screen.dart';
import 'package:tmdb/screens/logoff_screen.dart';
import 'package:tmdb/screens/music_library.dart';
import 'package:tmdb/screens/music_library_borrowed.dart';
import 'package:tmdb/utils/auth_settings.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late String _username;
  late String _headline = "Home";

  @override
  void initState() {
    super.initState();
    _username = "N/A";
    AuthSettings.localStorage
        .getUserName()
        .then((value) => _username = value!.split('@')[0]);
  }

  List<CollapsibleItem> get authItems {
    return [
      CollapsibleItem(
        text: 'Home',
        icon: Icons.home,
        onPressed: () => setState(() => _headline = 'Home'),
      ),
      CollapsibleItem(
          text: 'Search',
          icon: Icons.search,
          onPressed: () => setState(() => _headline = 'Search')),
    ];
  }

  List<CollapsibleItem> get nonAuthItems {
    return [
      CollapsibleItem(
          text: 'Home',
          icon: Icons.home,
          onPressed: () => setState(() => _headline = 'Home'),
          isSelected: true),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var authCubit = BlocProvider.of<AuthenticationCubit>(context);
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, state) {
      if (state is AuthenticationAuthenticated) {
        AuthSettings.localStorage.getUserName().then((value) {
          setState(() => _username = value!.split('@')[0]);
        });
        return Material(
            type: MaterialType.transparency,
            child: SafeArea(
                child: CollapsibleSidebar(
              isCollapsed: true,
              items: authItems,
              title: _username,
              onTitleTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          backgroundColor: Colors.transparent,
                          content: Container(
                              alignment: Alignment.center,
                              child: Container(
                                  height: 600.0,
                                  width: 600.0,
                                  child: LogoffScreen(cubit: authCubit))));
                    });
                    // setState(() {
                    //   nonAuthItems[0].isSelected = true;
                    // });
              },
              body: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.blueGrey[50],
                  child: _headline == "Home"
                      ? const MusicLibrary()
                      : const MusicLibraryBorrowed()),
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
      } else {
        AuthSettings.localStorage.getUserName().then((value) {
          setState(() => _username = value!.split('@')[0]);
        });
        var musicLibBloc = BlocProvider.of<MusicLibraryBloc>(context);
        

        return Material(
            type: MaterialType.transparency,
            child: SafeArea(
                child: CollapsibleSidebar(
              isCollapsed: true,
              items: nonAuthItems,
              title: "N/A",
              onTitleTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          backgroundColor: Colors.transparent,
                          content: Container(
                              alignment: Alignment.center,
                              child: Container(
                                  height: 600.0,
                                  width: 600.0,
                                  child: LoginScreen(
                                    cubit: authCubit,
                                    bloc: musicLibBloc,
                                  ))));
                    });
          
              },
              body: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.blueGrey[50],
                  child: _headline == "Home"
                      ? const MusicLibrary()
                      : const MusicLibraryBorrowed()),
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
    });
  }
}

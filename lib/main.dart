import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/gestures.dart';
import 'repositories/people_repository.dart';
import 'blocs/search/search_bloc.dart';
import 'blocs/search/search_event.dart';
import 'blocs/top250_movies/top250_movies_bloc.dart';
import 'blocs/top250_movies/top250_movies_event.dart';
import 'repositories/movies_repository.dart';
import 'screens/movies_people_search.dart';
import 'screens/top250_movies.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      title: 'TMDB App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(providers: [
        BlocProvider<SearchBloc>(
            create: (context) => SearchBloc(
                moviesRepository: MoviesRepository(),
                peopleRepository: PeopleRepository())),
        BlocProvider<Top250MoviesBloc>(
            create: (context) =>
                Top250MoviesBloc(moviesRepository: MoviesRepository())
                  ..add(const Top250MoviesFetchFirstEvent()))
      ], child: const MyHomePage(title: 'TMDB App')),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  bool _value = true;
  final TextEditingController _textController = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 700);

  static final List<Widget> _widgetOptions = <Widget>[
    const Top250Movies(),
    const MoviesPeopleSearch()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: _selectedIndex == 1
              ? [
                  Switch(
                      value: _value,
                      onChanged: (value) => setState(() {
                            _value = value;
                            _textController.text = "";
                            BlocProvider.of<SearchBloc>(context)
                                .add(const MoviesClearEvent());
                          })),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
                        child: TextField(
                          cursorColor: Colors.blue,
                          controller: _textController,
                          onChanged: (value) => _debouncer.run(() {
                            if (_value) {
                              BlocProvider.of<SearchBloc>(context)
                                  .add(MoviesSearchEvent(value));
                            } else {
                              BlocProvider.of<SearchBloc>(context)
                                  .add(PeopleSearchEvent(value));
                            }
                          }),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.only(
                                  left: 14.0, bottom: 8.0, top: 8.0),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0)),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 1.0),
                              ),
                              hintText:
                                  _value ? "Search Movies" : "Search Actors",
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.search),
                                color: const Color.fromRGBO(93, 25, 72, 1),
                                onPressed: () {},
                              )),
                        )),
                  )
                ]
              : [
                  Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          child: const Text("Top 250 Movies")))
                ]),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Top 250',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

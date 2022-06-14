import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb/blocs/authentication_cubit/authentication_cubit.dart';
import 'package:tmdb/blocs/music_library/music_library_bloc.dart';
import 'package:tmdb/blocs/music_library/music_library_event.dart';
import 'package:tmdb/repositories/accounts_repository.dart';
import 'package:tmdb/repositories/authentication_repository.dart';
import 'package:tmdb/repositories/music_tracks_repository.dart';
import 'package:tmdb/screens/main_screen.dart';
import 'package:tmdb/utils/auth_settings.dart';
import 'package:tmdb/utils/my_colors.dart';

class MyApp extends StatefulWidget {
  final Uri currentUrl;

  const MyApp({Key? key, required this.currentUrl}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Music Box',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: MultiRepositoryProvider(
            providers: [
              RepositoryProvider<AuthenticationRepository>(
                create: (context) => AuthenticationRepository(
                  localStorage: AuthSettings.localStorage,
                ),
              ),
              RepositoryProvider<AccountsRepository>(
                create: (context) =>
                    AccountsRepository(localStorage: AuthSettings.localStorage),
              ),
            ],
            child: MultiBlocProvider(providers: [
              BlocProvider<AuthenticationCubit>(
                lazy: false,
                create: (context) => AuthenticationCubit(
                    authenticationRepository:
                        context.read<AuthenticationRepository>(),
                    accountsRepository: context.read<AccountsRepository>())
                  ..onAppStart(currentUrl: widget.currentUrl),
              ),
              BlocProvider<MusicLibraryBloc>(
                  create: (context) => MusicLibraryBloc(
                      musicTracksRepository: MusicTracksRepository())
                    ..add(const MusicLibraryFetchEvent()))
            ], child: MainScreen())));
  }

  
}

// added because of issue with textfields long click if this is missing
class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}

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
import 'package:tmdb/screens/authentication_screen.dart';
import 'package:tmdb/screens/main_screen.dart';
import 'package:tmdb/screens/music_library.dart';
import 'package:tmdb/screens/not_found_screen.dart';
import 'package:tmdb/screens/splash_screen.dart';
import 'package:tmdb/utils/app_routes.dart';
import 'package:tmdb/utils/auth_settings.dart';
import 'package:tmdb/utils/my_beam_page.dart';
import 'package:tmdb/utils/my_colors.dart';

class MyApp extends StatefulWidget {
  final Uri currentUrl;

  const MyApp({Key? key, required this.currentUrl}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late BeamerDelegate routerDelegate;

  // @override
  // void initState() {
  //   super.initState();
  //   routerDelegate = BeamerDelegate(
  //     notFoundRedirectNamed: AppRoutes.notFound,
  //     locationBuilder: SimpleLocationBuilder(
  //       routes: {
  //         AppRoutes.root: (context, state) => MyBeamPage(
  //               title: "Not autheticated",
  //               child: const AuthenticationScreen(),
  //               showHeaderNavbarAndSidebar: false,
  //             ),
  //         AppRoutes.home: (context, state) => MyBeamPage(
  //               title: "Home",
  //               child: const MyHomePage(title: "Home"),
  //             ),
  //         AppRoutes.notFound: (context, state) => MyBeamPage(
  //               title: "Not Found",
  //               child: const NotFoundScreen(),
  //             ),
  //       },
  //     ),
  //     guards: [
  //       BeamGuard(
  //         pathBlueprints: [AppRoutes.root],
  //         check: (context, state) =>
  //             context.select((AuthenticationCubit authenticationCubit) {
  //           return authenticationCubit.state is AuthenticationUnauthenticated ||
  //               authenticationCubit.state is AuthenticationInitial ||
  //               authenticationCubit.state is AuthenticationAuthenticating ||
  //               authenticationCubit.state is AuthenticationSigningUp ||
  //               authenticationCubit.state is AuthenticationFailed ||
  //               authenticationCubit.state is AuthenticationSignUpFailed ||
  //               authenticationCubit.state is AuthenticationSigningUpCompleted;
  //         }),
  //         beamToNamed: AppRoutes.home,
  //       ),
  //       BeamGuard(
  //         pathBlueprints: [AppRoutes.home],
  //         check: (context, state) => context.select(
  //             (AuthenticationCubit authenticationCubit) =>
  //                 authenticationCubit.state is AuthenticationAuthenticated),
  //         beamToNamed: AppRoutes.root,
  //       )
  //     ],
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder(
  //     future: _initializeApp(),
  //     builder: (context, snapshot) {
  //       if (snapshot.hasData) {
  //         return snapshot.data as Widget;
  //       } else if (snapshot.hasError) {
  //         return Text('${snapshot.error}');
  //       }
  //       return SplashScreen();
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TMDB App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<MusicLibraryBloc>(
              create: (context) => MusicLibraryBloc(
                  musicTracksRepository: MusicTracksRepository())
                ..add(const MusicLibraryFetchEvent()))
        ],
        child: MainScreen()));
    
  }
  

  Future<Widget> _initializeApp() async {
    // await Future.delayed(const Duration(seconds: 3), () {});
    await Future.delayed(const Duration(milliseconds: 1), () {});
    return MultiBlocProvider(
        providers: [
          BlocProvider<MusicLibraryBloc>(
              create: (context) => MusicLibraryBloc(
                  musicTracksRepository: MusicTracksRepository())
                ..add(const MusicLibraryFetchEvent()))
        ],
        child: MultiRepositoryProvider(
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
          child: MultiBlocProvider(
            providers: [
              BlocProvider<AuthenticationCubit>(
                lazy: false,
                create: (context) => AuthenticationCubit(
                    authenticationRepository:
                        context.read<AuthenticationRepository>(),
                    accountsRepository: context.read<AccountsRepository>())
                  ..onAppStart(currentUrl: widget.currentUrl),
              ),
            ],
            child: BeamerProvider(
              routerDelegate: routerDelegate,
              child: MaterialApp.router(
                  routeInformationParser: BeamerParser(),
                  routerDelegate: routerDelegate,
                  debugShowCheckedModeBanner: false,
                  title: 'Music Box',
                  theme: ThemeData(
                    dividerColor: MyColors.dataTableRowDividerColor,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    brightness: Brightness.dark,
                  )),
            ),
          ),
        ));
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

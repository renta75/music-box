import 'dart:math';

import 'package:tmdb/utils/local_storage.dart';

class AuthSettings {
  static String get clientId {
    return 'Flutter';
  }

  static Uri get authorizationEndpoint {
    return Uri.parse('$sso/connect/authorize');
  }

  static Uri get tokenEndpoint {
    return Uri.parse('$sso/connect/token');
  }

  static Uri get sso {
    return Uri.parse('https://matrixcode.hr:7500');
  }

  static const String _charset =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';

  static String createCodeVerifier() {
    return List.generate(
        128, (i) => _charset[Random.secure().nextInt(_charset.length)]).join();
  }

  static final LocalStorage localStorage = LocalStorage();

  static String getToken() {
    final isLoggedIn = AuthSettings.localStorage.isLoggedIn;
    final hasClientToken = AuthSettings.localStorage.hasClientToken;

    if ((isLoggedIn || hasClientToken)) {
      final credentials = isLoggedIn
          ? AuthSettings.localStorage.credentials!
          : AuthSettings.localStorage.appCredentials!;
      return credentials.accessToken;
    } else {
      return "";
    }
  }
}

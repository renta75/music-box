import 'dart:async';

import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:shared_preferences/shared_preferences.dart';

const String PREF_CREDENTIALS = 'credentials';
const String PREF_APP_CREDENTIALS = 'credentials';
const String GRANT_CODE_VERIFIER = 'grant';
const String USER_ID = 'user_id';
const String USER_NAME = 'user_name';

class LocalStorage {
  oauth2.Credentials? _credentials;
  oauth2.Credentials? _appCredentials;
  oauth2.Credentials? get credentials => _credentials;
  oauth2.Credentials? get appCredentials => _appCredentials;
  bool get isLoggedIn => _credentials != null;
  bool get hasClientToken => _appCredentials != null;
  int? _userId;
  String? _userName;

  Future<void> setUserId(int userId) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt(USER_ID, userId);
    _userId = userId;
  }

  Future<void> setUserName(String userName) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(USER_NAME, userName);
    _userName = userName;
  }

  Future<String?> getUserName() async {
    
    if (_userName != null) {
      return _userName;
    }
    final sharedPreferences = await SharedPreferences.getInstance();
    final userName = sharedPreferences.getString(USER_NAME);
    if (userName != null) {
      _userName = _userName;
    }
    return userName;
  }

  Future<int?> getUserId() async {
    if (_userId != null) {
      return _userId;
    }
    final sharedPreferences = await SharedPreferences.getInstance();
    final userId = sharedPreferences.getInt(USER_ID);
    if (userId != null) {
      _userId = userId;
    }
    return userId;
  }

  Future<void> setCredentials(oauth2.Credentials credentials) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(PREF_CREDENTIALS, credentials.toJson());
    _credentials = credentials;
  }

  Future<void> setAppCredentials(oauth2.Credentials credentials) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
        PREF_APP_CREDENTIALS, credentials.toJson());
    _appCredentials = credentials;
  }

  Future<oauth2.Credentials?> getCredentials() async {
    if (_credentials != null) {
      return _credentials;
    }
    final sharedPreferences = await SharedPreferences.getInstance();
    final credentials = sharedPreferences.getString(PREF_CREDENTIALS);
    if (credentials != null) {
      if (credentials.isNotEmpty == true) {
        _credentials = oauth2.Credentials.fromJson(credentials);
      }
    }
    return _credentials;
  }

  Future<void> setGrantCodeVerifier(String codeVerifier) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(GRANT_CODE_VERIFIER, codeVerifier);
  }

  Future<String?> getGrantCodeVerifier() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final grant = sharedPreferences.getString(GRANT_CODE_VERIFIER);
    return grant;
  }

  Future<void> deleteGrantCodeVerifier() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey(GRANT_CODE_VERIFIER)) {
      await sharedPreferences.remove(GRANT_CODE_VERIFIER);
    }
  }

  Future<void> deleteCredentials() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    _credentials = null;
    if (sharedPreferences.containsKey(PREF_CREDENTIALS)) {
      await sharedPreferences.remove(PREF_CREDENTIALS);
    }
  }
}

import 'package:dio/dio.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:tmdb/models/user_info.dart';
import 'package:tmdb/utils/auth_settings.dart';
import 'package:tmdb/utils/local_storage.dart';

class AuthenticationRepository {
  final LocalStorage localStorage;
  AuthenticationRepository({required this.localStorage});

  Future<void> setCredentials(oauth2.Credentials credentials) async {
    return await localStorage.setCredentials(credentials);
  }

  Future<void> setAppCredentials(oauth2.Credentials credentials) async {
    return await localStorage.setAppCredentials(credentials);
  }

  Future<oauth2.Credentials?> getCredentials() async {
    return await localStorage.getCredentials();
  }

  Future<void> setGrantCodeVerifier({required String codeVerifier}) async {
    return await localStorage.setGrantCodeVerifier(codeVerifier);
  }

  Future<String?> getGrantCodeVerifier() async {
    return await localStorage.getGrantCodeVerifier();
  }

  Future<void> deleteGrantCodeVerifier() async {
    return await localStorage.deleteGrantCodeVerifier();
  }

  Future<void> deleteCredentials() async {
    return await localStorage.deleteCredentials();
  }

  Uri get oauthIdentity => AuthSettings.sso;

  Future<UserInfo> userInfoEndpoint() async {
    Dio dio = Dio();

    var apidata = await dio.get('$oauthIdentity/connect/userinfo');
    return UserInfo.fromJson(apidata.data);
  }
}

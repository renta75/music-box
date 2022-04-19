import 'package:dio/dio.dart';
import 'package:tmdb/models/user_info.dart';
import 'package:tmdb/utils/auth_settings.dart';
import 'package:tmdb/utils/local_storage.dart';

class AccountsRepository {
  final LocalStorage localStorage;
  AccountsRepository({required this.localStorage});

  Future<UserInfo> getCurrentAccount() async {
    return await userInfoEndpoint();
  }

  Future<void> setUserName(String userName) async {
    return await localStorage.setUserName(userName);
  }

  Future<void> signUp({required Map<String, String?> requestBody}) async {
    return await postAccount(requestBody: requestBody);
  }

  Future<void> activateInvitation({required String url}) async {
    return await activateInvitation(url: url);
  }

  Uri get oauthIdentity => AuthSettings.sso;

  

  Future<UserInfo> userInfoEndpoint() async {
    Dio dio = Dio();

    var apidata = await dio.get('$oauthIdentity/connect/userinfo',
        options: Options(headers: {'Authorization': 'Bearer ${AuthSettings.getToken()}'}));

    return UserInfo.fromJson(apidata.data);
  }

  Future<dynamic> postAccount(
      {required Map<String, String?> requestBody}) async {
    Dio dio = Dio();
    return await dio.post('$oauthIdentity/register', data: requestBody);
  }

  Future<dynamic>? activateInvitationGet({required String url}) async {
    Dio dio = Dio();
    return await dio.get(url,
        options: Options(headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': '*',
          'Access-Control-Allow-Methods': 'GET'
        }));
  }
}

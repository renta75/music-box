import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:tmdb/repositories/accounts_repository.dart';
import 'package:tmdb/repositories/authentication_repository.dart';
import 'package:tmdb/utils/auth_settings.dart';
part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit(
      {required this.authenticationRepository,
      required this.accountsRepository})
      : super(AuthenticationInitial());
  final AuthenticationRepository authenticationRepository;
  final AccountsRepository accountsRepository;

  void onAppStart({required Uri currentUrl}) async {
    final credentials = await authenticationRepository.getCredentials();
    if (credentials != null && credentials.isExpired == false) {
      emit(AuthenticationAuthenticated(credentials: credentials));
    } else if (credentials != null && credentials.isExpired == true) {
      try {
        final newCredentials =
            await credentials.refresh(identifier: AuthSettings.clientId);
        await authenticationRepository.setCredentials(newCredentials);
        emit(AuthenticationAuthenticated(credentials: newCredentials));
      } catch (error) {
        await authenticationRepository.deleteCredentials();
        await authenticationRepository.deleteGrantCodeVerifier();
        log('Error refreshing credentials $error');
        emit(AuthenticationUnauthenticated());
      }
    } else {
      final grant = await getGrant();
      final queryParameters = currentUrl.queryParameters;
      if (queryParameters.containsKey('code')) {
        try {
          final client =
              await grant.handleAuthorizationResponse(queryParameters);
          await authenticationRepository.setCredentials(client.credentials);
          emit(AuthenticationAuthenticated(credentials: client.credentials));
          client.close();
        } catch (error) {
          await authenticationRepository.deleteCredentials();
          await authenticationRepository.deleteGrantCodeVerifier();
          log('Error checking the token $error');
          emit(AuthenticationUnauthenticated());
        }
      } else {
        // html.window.location.assign(authorizationUrl);
      }
    }
  }

  Future<oauth2.AuthorizationCodeGrant> getGrant() async {
    final savedCodeVerifier =
        await authenticationRepository.getGrantCodeVerifier();
    if (savedCodeVerifier != null) {
      final savedGrant = oauth2.AuthorizationCodeGrant(AuthSettings.clientId,
          AuthSettings.authorizationEndpoint, AuthSettings.tokenEndpoint,
          codeVerifier: savedCodeVerifier);
      await authenticationRepository.deleteGrantCodeVerifier();
      return savedGrant;
    }

    final newCodeVerifier = AuthSettings.createCodeVerifier();
    final newGrant = oauth2.AuthorizationCodeGrant(AuthSettings.clientId,
        AuthSettings.authorizationEndpoint, AuthSettings.tokenEndpoint,
        codeVerifier: newCodeVerifier);

    await authenticationRepository.setGrantCodeVerifier(
        codeVerifier: newCodeVerifier);
    return newGrant;
  }

  Future<void> makeLogin(
      {required String email, required String password}) async {
    try {
      emit(AuthenticationAuthenticating());
      final authorizationUrl = AuthSettings.tokenEndpoint;

      var client = await oauth2.resourceOwnerPasswordGrant(
          authorizationUrl, email, password,
          identifier: AuthSettings.clientId,
          secret: 'secret',
          scopes: ['api1', 'openid'],
          basicAuth: false);

      await authenticationRepository.setCredentials(client.credentials);
      //final userInfo = await accountsRepository.getCurrentAccount();
      //await accountsRepository.setUserName(userInfo.userFullName);

      AuthSettings.localStorage.setUserName(email);

      emit(AuthenticationAuthenticated(credentials: client.credentials));
      client.close();
    } catch (err) {
      emit(AuthenticationFailed());
    }
  }

  Future<void> signup({
    required String email,
    required String password,
    required String name,
    String? companyName,
    String? accountName,
    String? invitattionUrl,
  }) async {
    try {
      emit(AuthenticationSigningUp());

      final authorizationUrl = AuthSettings.tokenEndpoint;

      var client = await oauth2.clientCredentialsGrant(
        authorizationUrl,
        'trusted-login',
        'trusted-secret',
        scopes: ['IdentityServerApi', 'create-users'],
      );

      await authenticationRepository.setAppCredentials(client.credentials);

      await accountsRepository.signUp(requestBody: {
        'Email': email,
        'FullName': name,
        'AccountName': accountName,
        'CompanyName': companyName,
        'Password': password
      });

      if (invitattionUrl != null) {
        invitattionUrl = Uri.decodeFull(invitattionUrl);
        await accountsRepository.activateInvitation(url: invitattionUrl);
      }

      // emit(AuthenticationSigningUpCompleted());
      await makeLogin(email: email, password: password);
    } catch (err) {
      emit(AuthenticationSignUpFailed());
    }
  }

  Future<void> logout() async {
    final credentials = await authenticationRepository.getCredentials();
    if (credentials != null) {
      await authenticationRepository.deleteCredentials();
      await authenticationRepository.deleteGrantCodeVerifier();
    }
    emit(AuthenticationUnauthenticated());
  }
}

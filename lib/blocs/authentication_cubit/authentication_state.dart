part of 'authentication_cubit.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationAuthenticating extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {
  final oauth2.Credentials credentials;

  const AuthenticationAuthenticated({required this.credentials});

   @override
  List<Object?> get props => [credentials];
}

class AuthenticationFailed extends AuthenticationState {}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationSigningUp extends AuthenticationState {}

class AuthenticationSigningUpCompleted extends AuthenticationState {}

class AuthenticationSignUpFailed extends AuthenticationState {}
part of 'auth_bloc.dart';

@immutable
sealed class AuthStates {}

final class InitialAuthState extends AuthStates {}

final class LoadingAuthState extends AuthStates {}

final class LoadedAuthState extends AuthStates {}

final class ErrorAuthState extends AuthStates {
  final String errorMessage;

  ErrorAuthState({required this.errorMessage});
}

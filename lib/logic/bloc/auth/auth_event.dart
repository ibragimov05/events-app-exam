part of 'auth_bloc.dart';

@immutable
sealed class AuthEvents {}

final class LoginUserEvent extends AuthEvents {
  final String email;
  final String password;

  LoginUserEvent({required this.email, required this.password});
}

final class RegisterUserEvent extends AuthEvents {
  final String email;
  final String password;

  RegisterUserEvent({required this.email, required this.password});
}

final class LogoutUserEvent extends AuthEvents {}

final class ResetUserPasswordEvent extends AuthEvents {
  final String email;

  ResetUserPasswordEvent({required this.email});
}

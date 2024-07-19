part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class InitialUserState extends UserState {}

class LoadingUserState extends UserState {}

class UserInfoLoadedState extends UserState {
  final String id;
  final String name;
  final String surname;
  final String email;
  final String imageUrl;
  final List<String> favoriteEvents;
  final List<String> registeredEvents;
  final List<String> canceledEvents;

  UserInfoLoadedState({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.imageUrl,
    required this.favoriteEvents,
    required this.registeredEvents,
    required this.canceledEvents,
  });
}

class LoadedWithoutAddingState extends UserState {
  final String id;
  final String name;
  final String surname;
  final String email;
  final String imageUrl;
  final List<String> favoriteEvents;
  final List<String> registeredEvents;
  final List<String> canceledEvents;

  LoadedWithoutAddingState({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.imageUrl,
    required this.favoriteEvents,
    required this.registeredEvents,
    required this.canceledEvents,
  });
}

class ErrorUserState extends UserState {
  final String error;

  ErrorUserState({required this.error});
}

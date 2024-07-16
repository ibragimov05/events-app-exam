part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class FetchUserInfoEvent extends UserEvent {}

class EditUserNameEvent extends UserEvent {
  final String id;
  final String newUserName;

  EditUserNameEvent({required this.id, required this.newUserName});
}

class EditUserSurnameEvent extends UserEvent {
  final String id;
  final String newUserSurname;

  EditUserSurnameEvent({required this.id, required this.newUserSurname});
}

class EditUserImageEvent extends UserEvent {
  final String id;
  final String newUserImage;

  EditUserImageEvent({required this.id, required this.newUserImage});
}

import 'package:bloc/bloc.dart';
import 'package:events_app_exam/data/models/user.dart';
import 'package:events_app_exam/logic/services/http/user_http_service.dart';
import 'package:events_app_exam/logic/services/shared_preference_service/user_shared_preference_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'user_state.dart';
part 'user_event.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(InitialUserState()) {
    on<FetchUserInfoEvent>(_fetchUserInfo);
    on<EditUserNameEvent>(_editUserName);
    on<EditUserSurnameEvent>(_editUserSurname);
    on<EditUserImageEvent>(_editUserImage);
  }

  final UserSharedPrefService _userSharedPrefService = UserSharedPrefService();
  final UserHttpService _userHttpService = UserHttpService();

  Future<void> _fetchUserInfo(
    FetchUserInfoEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(LoadingUserState());
    try {
      final name = await _userSharedPrefService.getUserFirstName();
      final surname = await _userSharedPrefService.getUserLastName();
      final email = await _userSharedPrefService.getUserEmail();
      final imageUrl = await _userSharedPrefService.getUserImageUrl();
      final id = await _userSharedPrefService.getUserId();

      emit(UserInfoLoadedState(
        id: id,
        name: name,
        surname: surname,
        email: email,
        imageUrl: imageUrl,
      ));
    } catch (e) {
      emit(ErrorUserState(error: e.toString()));
    }
  }

  Future<void> _editUserName(
    EditUserNameEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(LoadingUserState());
    try {
      await _userSharedPrefService.setUserFirstName(event.newUserName);

      final User user = await _userHttpService.editUser(
        id: event.id,
        firstName: event.newUserName,
      );

      emit(UserInfoLoadedState(
        id: user.id,
        name: user.firstName,
        surname: user.lastName,
        email: user.email,
        imageUrl: user.imageUrl,
      ));
    } catch (e) {
      emit(ErrorUserState(error: e.toString()));
    }
  }

  Future<void> _editUserSurname(
    EditUserSurnameEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(LoadingUserState());
    try {
      await _userSharedPrefService.setUserLastName(event.newUserSurname);

      final User user = await _userHttpService.editUser(
        id: event.id,
        lastName: event.newUserSurname,
      );

      emit(UserInfoLoadedState(
        id: user.id,
        name: user.firstName,
        surname: user.lastName,
        email: user.email,
        imageUrl: user.imageUrl,
      ));
    } catch (e) {
      emit(ErrorUserState(error: e.toString()));
    }
  }

  Future<void> _editUserImage(
    EditUserImageEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(LoadingUserState());
    try {
      final imageUrl = event.newUserImage;

      await _userSharedPrefService.setUserImageUrl(imageUrl);

      final User user = await _userHttpService.editUser(
        id: event.id,
        imageUrl: imageUrl,
      );

      emit(UserInfoLoadedState(
        id: user.id,
        name: user.firstName,
        surname: user.lastName,
        email: user.email,
        imageUrl: user.imageUrl,
      ));
    } catch (e) {
      emit(ErrorUserState(error: e.toString()));
    }
  }
}

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
    on<AddFavoriteEvent>(_addFavoriteEvent);
    on<AddNewParticipatingEvent>(_addParticipatingEvent);
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
      final favoriteEvents =
          await _userSharedPrefService.getUserFavoriteEvents();
      final registeredEvents =
          await _userSharedPrefService.getUserRegisteredEvents();
      final canceledEvents =
          await _userSharedPrefService.getUserCanceledEvents();

      emit(UserInfoLoadedState(
        id: id,
        name: name,
        surname: surname,
        email: email,
        imageUrl: imageUrl,
        favoriteEvents: favoriteEvents,
        registeredEvents: registeredEvents,
        canceledEvents: canceledEvents,
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
        favoriteEvents: user.favoriteEventsId,
        registeredEvents: user.registeredEventsId,
        canceledEvents: user.canceledEvents,
      ));
      add(FetchUserInfoEvent());
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
        favoriteEvents: user.favoriteEventsId,
        registeredEvents: user.registeredEventsId,
        canceledEvents: user.canceledEvents,
      ));
      add(FetchUserInfoEvent());
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

      emit(
        UserInfoLoadedState(
          id: user.id,
          name: user.firstName,
          surname: user.lastName,
          email: user.email,
          imageUrl: user.imageUrl,
          favoriteEvents: user.favoriteEventsId,
          registeredEvents: user.registeredEventsId,
          canceledEvents: user.canceledEvents,
        ),
      );
      add(FetchUserInfoEvent());
    } catch (e) {
      emit(ErrorUserState(error: e.toString()));
    }
  }

  Future<void> _addFavoriteEvent(
    AddFavoriteEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(LoadingUserState());
    try {
      final String eventID = event.eventId;

      await _userSharedPrefService.addFavoriteEvent(eventID);
      final data = await _userSharedPrefService.getUserFavoriteEvents();
      data.add(eventID);
      final User user = await _userHttpService.editUser(
        id: event.id,
        favoriteEventsId: data,
      );

      emit(
        UserInfoLoadedState(
          id: user.id,
          name: user.firstName,
          surname: user.lastName,
          email: user.email,
          imageUrl: user.imageUrl,
          favoriteEvents: user.favoriteEventsId,
          registeredEvents: user.registeredEventsId,
          canceledEvents: user.canceledEvents,
        ),
      );
    } catch (e) {
      emit(ErrorUserState(error: e.toString()));
    }
  }

  Future<void> _addParticipatingEvent(
    AddNewParticipatingEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(LoadingUserState());
    try {
      final String eventID = event.eventId;

      final isAdded = await _userSharedPrefService.addRegisteredEvent(eventID);
      if (isAdded) {
        final List<String> registeredEvents =
            await _userSharedPrefService.getUserRegisteredEvents();

        final User user = await _userHttpService.editUser(
          id: event.userId,
          registeredEventsId: registeredEvents,
        );

        emit(
          UserInfoLoadedState(
            id: user.id,
            name: user.firstName,
            surname: user.lastName,
            email: user.email,
            imageUrl: user.imageUrl,
            favoriteEvents: user.favoriteEventsId,
            registeredEvents: user.registeredEventsId,
            canceledEvents: user.canceledEvents,
          ),
        );
      } else {
        final User user = await _userHttpService.getUser(
          email: await _userSharedPrefService.getUserEmail(),
          uid: await _userSharedPrefService.getUserUid(),
        );
        emit(
          LoadedWithoutAddingState(
            id: user.id,
            name: user.firstName,
            surname: user.lastName,
            email: user.email,
            imageUrl: user.imageUrl,
            favoriteEvents: user.favoriteEventsId,
            registeredEvents: user.registeredEventsId,
            canceledEvents: user.canceledEvents,
          ),
        );
      }
    } catch (e) {
      emit(ErrorUserState(error: e.toString()));
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:events_app_exam/data/models/user.dart' as u;
import 'package:events_app_exam/logic/services/firebase/firebase_auth_service.dart';
import 'package:events_app_exam/logic/services/shared_preference_service/user_shared_preference_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../services/http/user_http_service.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvents, AuthStates> {
  final FirebaseAuthService firebaseAuthService;
  final UserHttpService userHttpService;
  final UserSharedPrefService userSharedPreferenceService;
  AuthBloc({
    required this.firebaseAuthService,
    required this.userHttpService,
    required this.userSharedPreferenceService,
  }) : super(InitialAuthState()) {
    on<LoginUserEvent>(_loginUserEvent);
    on<RegisterUserEvent>(_registerUserEvent);
    on<LogoutUserEvent>(_logoutUserEvent);
    on<ResetUserPasswordEvent>(_resetUserPasswordEvent);
  }

  Future<void> _loginUserEvent(
      LoginUserEvent event, Emitter<AuthStates> emit) async {
    emit(LoadingAuthState());
    try {
      final u.User user = await firebaseAuthService.loginUser(
        email: event.email,
        password: event.password,
      );

      await userSharedPreferenceService.addUser(user);

      emit(LoadedAuthState());
    } on FirebaseAuthException catch (e) {
      emit(ErrorAuthState(errorMessage: 'firebase error: $e'));
      rethrow;
    } catch (e) {
      emit(ErrorAuthState(errorMessage: 'error: $e'));
      rethrow;
    }
  }

  Future<void> _registerUserEvent(
      RegisterUserEvent event, Emitter<AuthStates> emit) async {
    emit(LoadingAuthState());
    try {
      await firebaseAuthService.registerUser(
        email: event.email,
        password: event.password,
      );

      final String uid = FirebaseAuth.instance.currentUser!.uid;
      final String userFCMToken =
          await FirebaseMessaging.instance.getToken() ?? '';

      final u.User user = await userHttpService.addUser(
        uid: uid,
        userFCMToken: userFCMToken,
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
      );

      await userSharedPreferenceService.addUser(user);

      emit(LoadedAuthState());
    } on FirebaseAuthException catch (e) {
      emit(ErrorAuthState(errorMessage: 'firebase error: $e'));
      rethrow;
    } catch (e) {
      emit(ErrorAuthState(errorMessage: 'error: $e'));
      rethrow;
    }
  }

  Future<void> _logoutUserEvent(
      LogoutUserEvent event, Emitter<AuthStates> emit) async {
    emit(LoadingAuthState());
    try {
      await firebaseAuthService.logoutUser();
      emit(LoadedAuthState());
    } on FirebaseAuthException catch (e) {
      emit(ErrorAuthState(errorMessage: 'firebase error: $e'));
      rethrow;
    } catch (e) {
      emit(ErrorAuthState(errorMessage: 'error: $e'));
      rethrow;
    }
  }

  Future<void> _resetUserPasswordEvent(
      ResetUserPasswordEvent event, Emitter<AuthStates> emit) async {
    emit(LoadingAuthState());
    try {
      await firebaseAuthService.resetPassword(email: event.email);
      emit(LoadedAuthState());
    } on FirebaseAuthException catch (e) {
      emit(ErrorAuthState(errorMessage: 'firebase error: $e'));
      rethrow;
    } catch (e) {
      emit(ErrorAuthState(errorMessage: 'error: $e'));
      rethrow;
    }
  }
}

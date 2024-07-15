import 'package:bloc/bloc.dart';
import 'package:events_app_exam/logic/services/firebase/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../services/firebase/firestore_user_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvents, AuthStates> {
  final FirebaseAuthService firebaseAuthService;
  final FirestoreUserService firestoreUserService;
  AuthBloc({
    required this.firebaseAuthService,
    required this.firestoreUserService,
  }) : super(InitialAuthState()) {
    on<LoginUserEvent>(_loginUserEvent);
    on<RegisterUserEvent>(_registerUserEvent);
    on<LogoutUserEvent>(_logoutUserEvent);
    on<ResetUserPasswordEvent>(_resetUserPassswordEvent);
  }

  Future<void> _loginUserEvent(
      LoginUserEvent event, Emitter<AuthStates> emit) async {
    emit(LoadingAuthState());
    try {
      await firebaseAuthService.loginUser(
        email: event.email,
        password: event.password,
      );
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

      await firestoreUserService.addUser(
        uid: FirebaseAuth.instance.currentUser!.uid,
        userFCMToken: await FirebaseMessaging.instance.getToken() ?? '',
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
      );

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

  Future<void> _resetUserPassswordEvent(
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

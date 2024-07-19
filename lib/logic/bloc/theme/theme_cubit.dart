import 'package:bloc/bloc.dart';
import 'package:events_app_exam/logic/bloc/theme/theme_state.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(LightModeState(themeData: ThemeData.dark()));

  void onDarkTapped() {

  }
}

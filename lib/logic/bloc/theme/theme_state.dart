import 'package:flutter/material.dart';

sealed class ThemeState {}

class DarkModeState extends ThemeState {
  final ThemeData themeData;

  DarkModeState({required this.themeData});
}

class LightModeState extends ThemeState {
  final ThemeData themeData;

  LightModeState({required this.themeData});
}

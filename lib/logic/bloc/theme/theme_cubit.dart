import 'package:bloc/bloc.dart';
import 'package:events_app_exam/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(AppConstants.themeValue);

  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('theme', !state);
    emit(!state);
  }
}

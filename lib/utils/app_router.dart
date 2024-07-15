import 'package:events_app_exam/ui/screens/login_screen/login_screen.dart';
import 'package:events_app_exam/ui/screens/my_events_screen/my_events_screen.dart';
import 'package:events_app_exam/ui/screens/password_recovey_screen/password_recovery_screen.dart';
import 'package:events_app_exam/ui/screens/profile_screen/profile_screen.dart';
import 'package:events_app_exam/ui/screens/signup_screen/sign_up_screen.dart';
import 'package:flutter/cupertino.dart';

class AppRouter {
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String passwordRecovery = '/passwordRecovery';
  static const String myEvents = '/myEvents';
  static const String profile = '/profile';

  static PageRoute _buildPageRoute(Widget widget) {
    return CupertinoPageRoute(builder: (BuildContext context) => widget);
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouter.login:
        return _buildPageRoute(const LoginScreen());
      case AppRouter.signUp:
        return _buildPageRoute(const SignUpScreen());
      case AppRouter.passwordRecovery:
        return _buildPageRoute(const PasswordRecoveryScreen());
      case AppRouter.myEvents:
        return _buildPageRoute(const MyEventsScreen());
      case AppRouter.profile:
        return _buildPageRoute(const ProfileScreen());
     
      default:
        return _buildPageRoute(const LoginScreen());
    }
  }
}

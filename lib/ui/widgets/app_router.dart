import 'package:events_app_exam/ui/screens/login_screen/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class AppRouter {
  static const String login = '/login';

  static PageRoute _buildPageRoute(Widget widget) {
    return CupertinoPageRoute(builder: (BuildContext context) => widget);
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouter.login:
        return _buildPageRoute(LoginScreen());
      default:
        return _buildPageRoute(LoginScreen());
    }
  }
}

import 'package:events_app_exam/logic/bloc/theme/theme_cubit.dart';
import 'package:events_app_exam/ui/screens/home_screen/home_screen.dart';
import 'package:events_app_exam/ui/screens/login_screen/login_screen.dart';
import 'package:events_app_exam/utils/app_router.dart';
import 'package:events_app_exam/utils/app_text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventsApp extends StatelessWidget {
  const EventsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRouter.generateRoute,
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              centerTitle: true,
              titleTextStyle: AppTextStyles.comicSans.copyWith(
                fontSize: 22,
                color: Colors.black,
              ),
            ),
          ),
          darkTheme: ThemeData.dark(),
          themeMode: state ? ThemeMode.dark : ThemeMode.light,
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const HomeScreen();
              } else {
                return const LoginScreen();
              }
            },
          ),
        );
      },
    );
  }
}

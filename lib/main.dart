import 'package:events_app_exam/core/app.dart';
import 'package:events_app_exam/firebase_options.dart';
import 'package:events_app_exam/logic/bloc/auth/auth_bloc.dart';
import 'package:events_app_exam/logic/bloc/user/user_bloc.dart';
import 'package:events_app_exam/logic/services/firebase/firebase_auth_service.dart';
import 'package:events_app_exam/logic/services/http/user_http_service.dart';
import 'package:events_app_exam/logic/services/location/location_service.dart';
import 'package:events_app_exam/logic/services/shared_preference_service/user_shared_preference_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocationService.checkPermissions();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => AuthBloc(
            firebaseAuthService: FirebaseAuthService(),
            userHttpService: UserHttpService(),
            userSharedPreferenceService: UserSharedPrefService(),
          ),
        ),
        BlocProvider(create: (BuildContext context) => UserBloc()),
      ],
      child: const EventsApp(),
    ),
  );
}

import 'package:events_app_exam/core/app.dart';
import 'package:events_app_exam/firebase_options.dart';
import 'package:events_app_exam/logic/bloc/auth/auth_bloc.dart';
import 'package:events_app_exam/logic/services/firebase/firebase_auth_service.dart';
import 'package:events_app_exam/logic/services/firebase/firestore_user_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            firebaseAuthService: FirebaseAuthService(),
            firestoreUserService: FirestoreUserService(),
          ),
        ),
      ],
      child: const EventsApp(),
    ),
  );
}

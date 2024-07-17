import 'package:events_app_exam/logic/services/firebase/firebase_event_service.dart';
import 'package:events_app_exam/logic/services/shared_preference_service/user_shared_preference_service.dart';
import 'package:events_app_exam/ui/widgets/arrow_back_button.dart';
import 'package:events_app_exam/utils/app_router.dart';
import 'package:flutter/material.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  final FirebaseEventService _eventService = FirebaseEventService();

  @override
  void initState() {
    super.initState();
    UserSharedPrefService().getUserId().then(
      (value) {
        print(value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UserSharedPrefService().getUserId().then(
      (value) {
        print(value);
      },
    );
    // String creatorId = await UserSharedPrefService().getUserId();
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          leading: const ArrowBackButton(),
          title: const Text('My events'),
        ),
        body: TabBar(
          tabs: [
            MyEventsScreen(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRouter.addEvent);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

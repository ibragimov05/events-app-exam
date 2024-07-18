import 'package:events_app_exam/ui/screens/my_events_screen/canceled_events.dart';
import 'package:events_app_exam/ui/screens/my_events_screen/my_events.dart';
import 'package:events_app_exam/ui/screens/my_events_screen/near_events.dart';
import 'package:events_app_exam/ui/screens/my_events_screen/participated_events.dart';
import 'package:events_app_exam/ui/widgets/arrow_back_button.dart';
import 'package:events_app_exam/utils/app_router.dart';
import 'package:flutter/material.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          leading: const ArrowBackButton(),
          title: const Text('My events'),
          bottom: const TabBar(
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.black,
            isScrollable: true,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Near'),
              Tab(text: 'Participated'),
              Tab(text: 'Canceled'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MyEvents(),
            NearEvents(),
            ParticipatedEvents(),
            CanceledEvents(),
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

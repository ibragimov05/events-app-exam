import 'package:events_app_exam/logic/services/shared_preference_service/user_shared_preference_service.dart';
import 'package:flutter/material.dart';

import '../../../data/models/event.dart';
import '../../../logic/services/firebase/firebase_event_service.dart';
import '../../widgets/event_widget.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  final FirebaseEventService _eventService = FirebaseEventService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserSharedPrefService().getUserId(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: _eventService.getUserEvents(snapshot.data ?? ''),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData || snapshot.hasError) {
                return Center(
                    child: Text('error: snapshot: ${snapshot.error}'));
              } else {
                final data = snapshot.data!.docs;
                return data.isNotEmpty
                    ? ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final Event event =
                              Event.fromQuerySnapshot(data[index]);
                          return EventWidget(event: event, isHomeScreen: false);
                        },
                      )
                    : const Center(child: Text('no events found'));
              }
            },
          );
        }
        return const CircularProgressIndicator();
      },
    );
  
  }
}

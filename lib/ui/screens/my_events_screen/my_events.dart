import 'package:flutter/material.dart';

import '../../../data/models/event.dart';
import '../../../logic/services/firebase/firebase_event_service.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  final FirebaseEventService _eventService = FirebaseEventService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _eventService.getUserEvents('-O1vEcL3jI8Ak8nhsafN'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.hasError) {
          return Center(child: Text('error: snapshot: ${snapshot.error}'));
        } else {
          final data = snapshot.data!.docs;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final Event event = Event.fromQuerySnapshot(data[index]);
              return ListTile(
                title: Text(event.name),
              );
            },
          );
        }
      },
    );
  }
}

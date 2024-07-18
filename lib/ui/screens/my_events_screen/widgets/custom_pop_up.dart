import 'package:events_app_exam/data/models/event.dart';
import 'package:events_app_exam/logic/services/firebase/firebase_event_service.dart';
import 'package:events_app_exam/ui/screens/my_events_screen/widgets/edit_event_dialog.dart';
import 'package:flutter/material.dart';

class CustomPopUp extends StatelessWidget {
  final Event event;

  const CustomPopUp({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String result) {
        if (result.toLowerCase() == 'edit') {
          showDialog(
            context: context,
            builder: (context) => EditEventDialog(event: event),
          );
        } else if (result.toLowerCase() == 'delete') {
          FirebaseEventService().deleteEvent(event.id);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'edit',
          child: Text('Edit'),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: Text('Delete'),
        ),
      ],
    );
  }
}

import 'package:events_app_exam/data/models/event.dart';
import 'package:events_app_exam/logic/services/firebase/firebase_event_service.dart';
import 'package:events_app_exam/ui/widgets/event_widget.dart';
import 'package:flutter/material.dart';

import '../../../logic/services/shared_preference_service/user_shared_preference_service.dart';

class GetEvents extends StatefulWidget {
  final bool isCanceled;
  final List<Event> Function(List<Event>, List<String>) eventFunction;

  const GetEvents(
      {super.key, required this.isCanceled, required this.eventFunction});

  @override
  State<GetEvents> createState() => _GetEventsState();
}

class _GetEventsState extends State<GetEvents> {
  final FirebaseEventService _eventService = FirebaseEventService();
  final UserSharedPrefService _prefService = UserSharedPrefService();
  List<String> _userParticipatingEvents = [];

  Future<String> _futureFunction() async {
    _userParticipatingEvents = await _prefService.getUserRegisteredEvents();
    return await UserSharedPrefService().getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureFunction(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: _eventService.getAllEvents(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData || snapshot.hasError) {
                return Center(
                  child: Text('error: snapshot: ${snapshot.error}'),
                );
              } else {
                final data = snapshot.data!.docs;
                final List<Event> events =
                    data.map((e) => Event.fromQuerySnapshot(e)).toList();
                final userParticipatingEvents =
                    widget.eventFunction(events, _userParticipatingEvents);
                return data.isNotEmpty
                    ? ListView.builder(
                        itemCount: userParticipatingEvents.length,
                        itemBuilder: (context, index) {
                          return EventWidget(
                            event: userParticipatingEvents[index],
                            isHomeScreen: false,
                          );
                        },
                      )
                    : const Center(
                        child: Text('no events found'),
                      );
              }
            },
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

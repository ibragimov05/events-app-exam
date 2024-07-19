import 'dart:convert';

import 'package:events_app_exam/data/models/event.dart';
import 'package:events_app_exam/logic/services/firebase/firebase_event_service.dart';
import 'package:events_app_exam/logic/services/http/user_http_service.dart';
import 'package:events_app_exam/logic/services/shared_preference_service/user_shared_preference_service.dart';
import 'package:events_app_exam/ui/screens/event_details_screen.dart/widgets/book_an_event.dart';
import 'package:events_app_exam/ui/screens/event_details_screen.dart/widgets/event_location_map.dart';
import 'package:events_app_exam/ui/screens/event_details_screen.dart/widgets/list_tile_widget.dart';
import 'package:events_app_exam/ui/widgets/arrow_back_button.dart';
import 'package:events_app_exam/ui/widgets/custom_main_orange_button.dart';
import 'package:events_app_exam/ui/widgets/image_with_loader.dart';
import 'package:events_app_exam/utils/app_functions.dart';
import 'package:events_app_exam/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final UserSharedPrefService _prefService = UserSharedPrefService();
  final FirebaseEventService _eventService = FirebaseEventService();
  List<String> eventsId = [];
  List<String> canceledEvents = [];

  Future<void> getInfo() async {
    eventsId = await _prefService.getUserRegisteredEvents();
    canceledEvents = await _prefService.getUserCanceledEvents();
  }

  void _onCancelTap() async {
    eventsId.removeWhere((element) => element == widget.event.id);
    canceledEvents.add(widget.event.id);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('registered-events', jsonEncode(eventsId));
    sharedPreferences.setString('canceled-events', jsonEncode(canceledEvents));
    await UserHttpService().editUser(
      id: await _prefService.getUserId(),
      registeredEventsId: eventsId,
      canceledEvents: canceledEvents,
    );

    _eventService.updatePeopleToEvent(
      widget.event.id,
      widget.event.attendingPeople - 1,
    );

    if (mounted) {
      _prefService.addCanceledEvent(widget.event.id);
      Navigator.of(context).pop();
      AppFunctions.showSnackBar(
        context,
        "Canceled successfully",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const ArrowBackButton(),
      ),
      body: ListView(
        children: [
          ImageWithLoader(
              imageUrl: widget.event.imageUrl, h: 300, w: double.infinity),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.event.name,
              style: AppTextStyles.comicSans.copyWith(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                EventCard(
                  icon: Icons.event,
                  text1: AppFunctions.getFormattedDate(widget.event.startTime),
                  text2:
                      '${AppFunctions.convertIntoDay(widget.event.startTime.toDate().weekday)}, ${AppFunctions.getFormattedTimeOfDay(widget.event.startTime)} - ${AppFunctions.getFormattedTimeOfDay(widget.event.endTime)}',
                ),
                EventCard(
                  icon: Icons.location_on,
                  text1: 'Location',
                  text2: widget.event.locationName,
                ),
                EventCard(
                  icon: Icons.event,
                  text1: '${widget.event.attendingPeople} people are attending',
                  text2: 'sign up too!',
                ),
                const Gap(20),
                Row(
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: ImageWithLoader(
                        imageUrl: widget.event.imageUrl,
                        h: 70,
                        w: 70,
                      ),
                    ),
                    const Gap(15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.event.creatorName,
                          style: AppTextStyles.comicSans,
                        ),
                        const Text(
                          'Event creator',
                          style: AppTextStyles.comicSans,
                        ),
                      ],
                    ),
                  ],
                ),
                const Gap(20),
                Text(
                  'About event',
                  style: AppTextStyles.comicSans.copyWith(fontSize: 16),
                ),
                Text(
                  widget.event.description,
                  style: AppTextStyles.comicSans,
                ),
                const Gap(20),
                const Text('Location'),
                Text(widget.event.locationName),
                const Gap(20),
                EventLocationMap(
                  eventLocation: Point(
                    latitude: widget.event.geoPoint.latitude,
                    longitude: widget.event.geoPoint.longitude,
                  ),
                ),
                const Gap(100),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: FutureBuilder(
          future: getInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (eventsId.contains(widget.event.id)) {
                if (widget.event.startTime.toDate().isAfter(DateTime.now())) {
                  return CustomMainOrangeButton(
                    color: Colors.red,
                    buttonText: 'Cancel event',
                    onTap: () => _onCancelTap(),
                  );
                } else {
                  return CustomMainOrangeButton(
                    buttonText: 'Already ended',
                    onTap: () {},
                    color: Colors.grey,
                  );
                }
              } else {
                return CustomMainOrangeButton(
                  buttonText: 'Register to event',
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => BookAnEvent(event: widget.event),
                    );
                  },
                );
              }
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

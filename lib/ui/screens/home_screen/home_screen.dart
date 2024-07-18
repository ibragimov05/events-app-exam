import 'package:carousel_slider/carousel_slider.dart';
import 'package:events_app_exam/logic/services/firebase/firebase_event_service.dart';
import 'package:events_app_exam/ui/screens/home_screen/widgets/home_screen_drawer.dart';
import 'package:events_app_exam/ui/screens/home_screen/widgets/home_screen_text_field.dart';
import 'package:events_app_exam/ui/screens/home_screen/widgets/seven_day_event.dart';
import 'package:events_app_exam/ui/widgets/event_widget.dart';
import 'package:events_app_exam/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../data/models/event.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseEventService _eventService = FirebaseEventService();
  final TextEditingController _eventTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main screen'),
        actions: [
          IconButton(
            onPressed: () async {},
            icon: const Icon(
              Icons.notifications_outlined,
              size: 30,
            ),
          ),
        ],
      ),
      drawer: const HomeScreenDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            HomeScreenTextField(
              onTuneTap: () {},
              textEditingController: _eventTextController,
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Events that are upcoming in seven days',
                style: AppTextStyles.comicSans,
              ),
            ),
            SizedBox(
              height: 200,
              child: StreamBuilder(
                stream: _eventService.getSevenDayEvents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData || snapshot.hasError) {
                    return Center(
                      child: Text('error snapshot: ${snapshot.error}'),
                    );
                  } else {
                    final data = snapshot.data!.docs;
                    return data.isNotEmpty
                        ? CarouselSlider(
                            options: CarouselOptions(),
                            items: List.generate(
                              data.length,
                              (index) => SevenDayEvent(
                                event: Event.fromQuerySnapshot(data[index]),
                              ),
                            ),
                          )
                        : const Center(
                            child: Text(
                              'No events available that is upcoming in seven days',
                            ),
                          );
                  }
                },
              ),
            ),
            StreamBuilder(
              stream: _eventService.getEvents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.hasError) {
                  return Center(
                    child: Text('error: snapshot ${snapshot.error}'),
                  );
                } else {
                  final data = snapshot.data!.docs;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final Event event =
                            Event.fromQuerySnapshot(data[index]);
                        return EventWidget(isHomeScreen: true, event: event);
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

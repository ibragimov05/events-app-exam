import 'package:events_app_exam/data/models/event.dart';
import 'package:events_app_exam/ui/screens/event_details_screen.dart/widgets/list_tile_widget.dart';
import 'package:events_app_exam/ui/widgets/arrow_back_button.dart';
import 'package:events_app_exam/ui/widgets/image_with_loader.dart';
import 'package:events_app_exam/utils/app_functions.dart';
import 'package:events_app_exam/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class EventDetailsScreen extends StatelessWidget {
  final Event event;
  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const ArrowBackButton(),
      ),
      body: ListView(
        children: [
          ImageWithLoader(imageUrl: event.imageUrl, h: 300, w: double.infinity),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              event.name,
              style: AppTextStyles.comicSans.copyWith(fontSize: 20),
            ),
          ),
          EventCard(
            icon: Icons.event,
            date: AppFunctions.getFormattedDate(event.startTime),
            timeRange: '2',
          ),
        ],
      ),
    );
  }
}

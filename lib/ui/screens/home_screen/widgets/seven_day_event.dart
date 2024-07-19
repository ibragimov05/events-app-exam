import 'package:events_app_exam/data/models/event.dart';
import 'package:events_app_exam/ui/widgets/image_with_loader.dart';
import 'package:events_app_exam/utils/app_colors.dart';
import 'package:events_app_exam/utils/app_functions.dart';
import 'package:events_app_exam/utils/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SevenDayEvent extends StatelessWidget {
  final Event event;

  const SevenDayEvent({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRouter.eventDetails, arguments: event);
      },
      child: Container(
        height: double.infinity,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.mainOrange.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppFunctions.getFormattedDate(event.startTime),
            ),
            ImageWithLoader(imageUrl: event.imageUrl, h: 100, w: 100),
            Text(event.name),
          ],
        ),
      ),
    );
  }
}

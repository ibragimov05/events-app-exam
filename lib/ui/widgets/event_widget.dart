import 'package:events_app_exam/data/models/event.dart';
import 'package:events_app_exam/ui/screens/home_screen/widgets/favorite_button_home_screen.dart';
import 'package:events_app_exam/ui/screens/my_events_screen/widgets/custom_pop_up.dart';
import 'package:events_app_exam/ui/widgets/image_with_loader.dart';
import 'package:events_app_exam/utils/app_functions.dart';
import 'package:events_app_exam/utils/app_router.dart';
import 'package:events_app_exam/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EventWidget extends StatefulWidget {
  final Event event;
  final bool isHomeScreen;

  const EventWidget({
    super.key,
    required this.isHomeScreen,
    required this.event,
  });

  @override
  State<EventWidget> createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isHomeScreen
          ? () {
              Navigator.pushNamed(
                context,
                AppRouter.eventDetails,
                arguments: widget.event,
              );
            }
          : null,
      child: Container(
        width: double.infinity,
        height: 120,
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withOpacity(0.7), width: 4),
        ),
        child: Row(
          children: [
            ImageWithLoader(
              imageUrl: widget.event.imageUrl,
              h: 70,
              w: 100,
            ),
            const Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.event.name,
                        style: AppTextStyles.comicSans.copyWith(fontSize: 12),
                      ),
                      if (widget.isHomeScreen)
                        FavoriteButtonHomeScreen(eventId: widget.event.id)
                      else
                        CustomPopUp(event: widget.event),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${AppFunctions.getFormattedTimeOfDay(widget.event.startTime)},',
                        style: AppTextStyles.comicSans,
                      ),
                      const Gap(5),
                      Text(
                        AppFunctions.getFormattedDate(widget.event.startTime),
                        style: AppTextStyles.comicSans,
                      ),
                    ],
                  ),
                  Expanded(
                    child: Text(
                      widget.event.locationName,
                      style: AppTextStyles.comicSans,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

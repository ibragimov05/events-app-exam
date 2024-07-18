import 'package:events_app_exam/data/models/event.dart';
import 'package:events_app_exam/ui/widgets/image_with_loader.dart';
import 'package:flutter/material.dart';

class BookAnEvent extends StatelessWidget {
  final Event _event;

  const BookAnEvent({
    super.key,
    required Event event,
  }) : _event = event;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 1.5,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: ImageWithLoader(
        h: 100,
        w: 100,
        imageUrl: _event.imageUrl,
      ),
    );
  }
}

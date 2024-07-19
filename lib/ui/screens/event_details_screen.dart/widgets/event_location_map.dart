import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class EventLocationMap extends StatelessWidget {
  final Point eventLocation;

  const EventLocationMap({super.key, required this.eventLocation});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        width: double.infinity,
        height: 300,
        child: YandexMap(
          // ignore: prefer_collection_literals
          gestureRecognizers: Set()
            ..add(Factory<EagerGestureRecognizer>(
                () => EagerGestureRecognizer())),
          onMapCreated: (controller) {
            controller.moveCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: eventLocation,
                  zoom: 17,
                ),
              ),
            );
          },
          mapObjects: [
            PlacemarkMapObject(
              mapId: const MapObjectId('event_location'),
              point: eventLocation,
              icon: PlacemarkIcon.single(
                PlacemarkIconStyle(
                  image: BitmapDescriptor.fromAssetImage(
                    "assets/images/place.png",
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

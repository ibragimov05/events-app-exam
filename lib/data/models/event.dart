import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String creatorId;
  final String name;
  final Timestamp startTime;
  final Timestamp endTime;
  final GeoPoint geoPoint;
  final String description;
  final String imageUrl;
  final String locationName;
  // final int attendingPeople;

  Event({
    required this.id,
    required this.creatorId,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.geoPoint,
    required this.description,
    required this.imageUrl,
    required this.locationName,
    // required this.attendingPeople,
  });

  factory Event.fromQuerySnapshot(QueryDocumentSnapshot query) {
    return Event(
      id: query.id,
      creatorId: query['creator-id'],
      name: query['name'],
      startTime: query['start-time'],
      endTime: query['end-time'],
      geoPoint: query['geo-point'],
      description: query['description'],
      imageUrl: query['image-url'],
      locationName: query['location-name'],
      // attendingPeople: query['attending-people'],
    );
  }
}

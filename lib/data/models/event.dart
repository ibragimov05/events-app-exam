import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String creatorId;
  final String name;
  final Timestamp time;
  final GeoPoint geoPoint;
  final String description;
  final String imageUrl;

  Event({
    required this.id,
    required this.creatorId,
    required this.name,
    required this.time,
    required this.geoPoint,
    required this.description,
    required this.imageUrl,
  });

  factory Event.fromQuerySnapshot(QueryDocumentSnapshot query) {
    return Event(
      id: query.id,
      creatorId: query['creator-id'],
      name: query['name'],
      time: query['time'],
      geoPoint: query['geo-point'],
      description: query['description'],
      imageUrl: query['image-url'],
    );
  }
}

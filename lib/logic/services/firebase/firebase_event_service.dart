import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseEventService {
  final _firestoreEvents = FirebaseFirestore.instance.collection('events');

  Stream<QuerySnapshot> getEvents() async* {
    yield* _firestoreEvents.snapshots();
  }

  Stream<QuerySnapshot> getUserEvents(String creatorId) {
    return _firestoreEvents
        .where('creator-id', isEqualTo: creatorId)
        .snapshots();
  }

  void addEvent({
    required String creatorId,
    required String name,
    required Timestamp time,
    required GeoPoint geoPoint,
    required String description,
    required String imageUrl,
  }) {
    _firestoreEvents.add({
      'creator-id': creatorId,
      'name': name,
      'time': time,
      'geo-point': geoPoint,
      'description': description,
      'image-url': imageUrl,
    });
  }
}

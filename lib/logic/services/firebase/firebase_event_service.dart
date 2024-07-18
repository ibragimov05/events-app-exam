import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseEventService {
  final _firestoreEvents = FirebaseFirestore.instance.collection('events');

  Stream<QuerySnapshot> getEvents() async* {
    yield* _firestoreEvents.snapshots();
  }

  Stream<QuerySnapshot> getSevenDayEvents() {
    DateTime now = DateTime.now();
    DateTime sevenDaysFromNow = DateTime.now().add(Duration(days: 7));

    Timestamp nowTS = Timestamp.fromDate(now);
    Timestamp sevenDaysFromNowTS = Timestamp.fromDate(sevenDaysFromNow);

    return _firestoreEvents
        .where('start-time', isGreaterThanOrEqualTo: nowTS)
        .where('start-time', isLessThanOrEqualTo: sevenDaysFromNowTS)
        .snapshots();
  }

  Stream<QuerySnapshot> getUserEvents(String creatorId) {
    return _firestoreEvents
        .where('creator-id', isEqualTo: creatorId)
        .snapshots();
  }

  void addEvent({
    required String creatorId,
    required String name,
    required Timestamp startTime,
    required Timestamp endTime,
    required GeoPoint geoPoint,
    required String description,
    required String imageUrl,
    required String locationName,
  }) {
    _firestoreEvents.add({
      'creator-id': creatorId,
      'name': name,
      'end-time': startTime,
      'start-time': endTime,
      'geo-point': geoPoint,
      'description': description,
      'image-url': imageUrl,
      'location-name': locationName,
    });
  }

  void editEvent() {}

  void deleteEvent(String id) => _firestoreEvents.doc(id).delete();
}

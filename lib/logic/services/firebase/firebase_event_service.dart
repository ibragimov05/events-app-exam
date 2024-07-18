import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/models/event.dart';

class FirebaseEventService {
  final _firestoreEvents = FirebaseFirestore.instance.collection('events');

  Stream<List<Event>> getEvents(String city) {
    return _firestoreEvents.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Event.fromQuerySnapshot(doc))
          .where(
            (event) =>
                event.locationName.toLowerCase().contains(city.toLowerCase()),
          )
          .toList();
    });
  }

  Stream<List<Event>> getSevenDayEvents(String city) {
    DateTime now = DateTime.now();
    DateTime sevenDaysFromNow = DateTime.now().add(const Duration(days: 7));

    Timestamp nowTS = Timestamp.fromDate(now);
    Timestamp sevenDaysFromNowTS = Timestamp.fromDate(sevenDaysFromNow);

    return _firestoreEvents
        .where('start-time', isGreaterThanOrEqualTo: nowTS)
        .where('start-time', isLessThanOrEqualTo: sevenDaysFromNowTS)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs
            .map((doc) => Event.fromQuerySnapshot(doc))
            .where(
              (event) =>
                  event.locationName.toLowerCase().contains(city.toLowerCase()),
            )
            .toList();
      },
    );
  }

  Stream<QuerySnapshot> getUserEvents(String creatorId) {
    return _firestoreEvents
        .where('creator-id', isEqualTo: creatorId)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllEvents() {
    return _firestoreEvents.snapshots();
  }

  void addEvent({
    required String creatorId,
    required String creatorName,
    required String creatorEmail,
    required String creatorImageUrl,
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
      'creator-email': creatorEmail,
      'creator-image-url': creatorImageUrl,
      'creator-name': creatorName,
      'name': name,
      'end-time': startTime,
      'start-time': endTime,
      'geo-point': geoPoint,
      'description': description,
      'image-url': imageUrl,
      'location-name': locationName,
      'attending-people': 0,
    });
  }

  void editEvent() {}

  void deleteEvent(String id) => _firestoreEvents.doc(id).delete();
}

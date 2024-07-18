class User {
  final String id;
  final String uid;
  final String userFCMToken;
  final String firstName;
  final String lastName;
  final String email;
  final String imageUrl;
  final List<String> favoriteEventsId;
  final List<String> registeredEventsId;
  final List<String> participatedEvents;
  final List<String> canceledEvents;

  const User({
    required this.id,
    required this.uid,
    required this.userFCMToken,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.imageUrl,
    required this.favoriteEventsId,
    required this.registeredEventsId,
    required this.participatedEvents,
    required this.canceledEvents,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      uid: json['uid'],
      userFCMToken: json['user-FCM-token'],
      firstName: json['first-name'],
      lastName: json['last-name'],
      email: json['email'],
      imageUrl: json['image-url'],
      favoriteEventsId: (json['favorite-events'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      registeredEventsId: (json['registered-events'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      participatedEvents: (json['participated-events'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      canceledEvents: (json['canceled-events'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
    );
  }
}

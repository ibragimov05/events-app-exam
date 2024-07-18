import 'dart:convert';
import 'package:events_app_exam/data/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as f;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UserHttpService {
  final String _firebaseCustomKey = dotenv.get('FIREBASE_CUSTOM_KEY');
  final String _baseUrl =
      'https://events-app-unique-default-rtdb.firebaseio.com';

  Future<User> getUser({
    required String email,
    required String uid,
  }) async {
    final String idToken = await _getIdToken() ?? '';

    final Uri url =
        Uri.parse('$_baseUrl/$_firebaseCustomKey/users.json?auth=$idToken');
    final http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> usersMap = jsonDecode(response.body);

      User? user;
      usersMap.forEach((key, value) {
        if (value['email'] == email && value['uid'] == uid) {
          value['id'] = key;
          user = User.fromJson(value);
          return;
        }
      });

      if (user != null) {
        return user!;
      } else {
        throw Exception('Could not find user: ${response.body}');
      }
    } else {
      throw Exception('Failed to get users: ${response.body}');
    }
  }

  Future<User> addUser({
    required String uid,
    required String userFCMToken,
    required String firstName,
    required String lastName,
    required String email,
    required List<String> favoriteEventsId,
    required List<String> registeredEventsId,
    required List<String> participatedEvents,
    required List<String> canceledEvents,
  }) async {
    final String idToken = await _getIdToken() ?? '';

    final Uri url =
        Uri.parse('$_baseUrl/$_firebaseCustomKey/users.json?auth=$idToken');
    Map<String, dynamic> userData = {
      'uid': f.FirebaseAuth.instance.currentUser?.uid ?? '',
      'user-FCM-token': userFCMToken,
      'first-name': firstName,
      'last-name': lastName,
      'email': email,
      'favorite-events': favoriteEventsId,
      'registered-events': registeredEventsId,
      'image-url':
          'https://cdn3.iconfinder.com/data/icons/social-messaging-productivity-6/128/profile-circle2-512.png',
      'canceled-events': canceledEvents,
      'participated-events': participatedEvents,
    };

    final http.Response response =
        await http.post(url, body: jsonEncode(userData));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      userData['id'] = data['name'];
      return User.fromJson(userData);
    } else {
      throw Exception(
        'Error adding user: status code ${response.statusCode}, body: ${response.body}',
      );
    }
  }

  Future<User> editUser({
    required String id,
    String? userFCMToken,
    String? firstName,
    String? lastName,
    String? email,
    String? imageUrl,
    List<String>? favoriteEventsId,
    List<String>? registeredEventsId,
    List<String>? participatedEvents,
    List<String>? canceledEvents,
  }) async {
    final String idToken = await _getIdToken() ?? '';
    final Uri url = Uri.parse(
      '$_baseUrl/$_firebaseCustomKey/users/$id.json?auth=$idToken',
    );

    Map<String, dynamic> updatedData = {
      if (userFCMToken != null) 'user-FCM-token': userFCMToken,
      if (firstName != null) 'first-name': firstName,
      if (lastName != null) 'last-name': lastName,
      if (email != null) 'email': email,
      if (imageUrl != null) 'image-url': imageUrl,
      if (favoriteEventsId != null) 'favorite-events': favoriteEventsId,
      if (registeredEventsId != null) 'registered-events': registeredEventsId,
      if (participatedEvents != null) 'canceled-events': canceledEvents,
      if (canceledEvents != null) 'participated-events': participatedEvents,
    };

    final http.Response response = await http.patch(
      url,
      body: jsonEncode(updatedData),
    );

    if (response.statusCode == 200) {
      final updatedUserData = {
        'id': id,
        'uid': f.FirebaseAuth.instance.currentUser?.uid ?? '',
        'user-FCM-token': userFCMToken ?? '',
        'first-name': firstName ?? '',
        'last-name': lastName ?? '',
        'email': email ?? '',
        'image-url': imageUrl ?? '',
        'favorite-events': favoriteEventsId ?? [],
        'registered-events': registeredEventsId ?? [],
      };

      return User.fromJson(updatedUserData);
    } else {
      throw Exception(
        'Error updating user: status code ${response.statusCode}, body: ${response.body}',
      );
    }
  }

  Future<String?> _getIdToken() async {
    final f.User? user = f.FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    throw Exception('No authenticated user found.');
  }
}

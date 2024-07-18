// import 'dart:convert';
// import 'package:events_app_exam/data/models/user.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class UserSharedPrefService {
//   SharedPreferences? _sharedPreferences;

//   Future<void> _initSharedPreferences() async {
//     _sharedPreferences ??= await SharedPreferences.getInstance();
//   }

//   Future<void> addUser(User user) async {
//     await _initSharedPreferences();

//     final Map<String, dynamic> userMap = {
//       'id': user.id,
//       'uid': user.uid,
//       'userFCMToken': user.userFCMToken,
//       'firstName': user.firstName,
//       'lastName': user.lastName,
//       'email': user.email,
//       'imageUrl': user.imageUrl,
//       'favorite-events': jsonEncode(user.favoriteEventsId),
//       'registered-events': jsonEncode(user.registeredEventsId),
//       'canceled-events': jsonEncode(user.canceledEvents),
//     };

//     for (var entry in userMap.entries) {
//       _sharedPreferences!.setString(entry.key, entry.value);
//     }
//   }

//   Future<String> _getString(String key, [String defaultValue = '']) async {
//     await _initSharedPreferences();
//     return _sharedPreferences!.getString(key) ?? defaultValue;
//   }

//   Future<void> _setString(String key, String value) async {
//     await _initSharedPreferences();
//     _sharedPreferences!.setString(key, value);
//   }

//   Future<String> getUserId() async => await _getString('id');

//   Future<String> getUserUid() async => await _getString('uid');

//   Future<String> getUserFCMToken() async => await _getString('userFCMToken');

//   Future<String> getUserFirstName() async =>
//       await _getString('firstName', 'unnamed');

//   Future<String> getUserLastName() async => await _getString('lastName');

//   Future<String> getUserEmail() async => await _getString('email');

//   Future<String> getUserImageUrl() async => await _getString('imageUrl');

//   Future<List<String>> _getEventList(String key) async {
//     await _initSharedPreferences();
//     final data = _sharedPreferences!.getString(key);
//     if (data == null || data.isEmpty) return [];
//     return (jsonDecode(data) as List<dynamic>).map((e) => e as String).toList();
//   }

//   Future<List<String>> getUserFavoriteEvents() async =>
//       await _getEventList('favorite-events');

//   Future<List<String>> getUserRegisteredEvents() async =>
//       await _getEventList('registered-events');

//   Future<List<String>> getUserCanceledEvents() async =>
//       await _getEventList('canceled-events');

//   Future<void> setUserId(String id) async => await _setString('id', id);

//   Future<void> setUserUid(String uid) async => await _setString('uid', uid);

//   Future<void> setUserFCMToken(String userFCMToken) async =>
//       await _setString('userFCMToken', userFCMToken);

//   Future<void> setUserFirstName(String firstName) async =>
//       await _setString('firstName', firstName);

//   Future<void> setUserLastName(String lastName) async =>
//       await _setString('lastName', lastName);

//   Future<void> setUserEmail(String email) async =>
//       await _setString('email', email);

//   Future<void> setUserImageUrl(String imageUrl) async =>
//       await _setString('imageUrl', imageUrl);

//   Future<bool> _addEvent(String key, String eventId) async {
//     await _initSharedPreferences();
//     List<String> data = await _getEventList(key);
//     if (!data.contains(eventId)) {
//       data.add(eventId);
//       _sharedPreferences!.setString(key, jsonEncode(data));
//       return true;
//     }
//     return false;
//   }

//   Future<bool> addRegisteredEvent(String eventId) async =>
//       await _addEvent('registered-events', eventId);

//   Future<bool> addFavoriteEvent(String eventId) async =>
//       await _addEvent('favorite-events', eventId);

//   Future<bool> addCanceledEvent(String eventId) async =>
//       await _addEvent('canceled-events', eventId);
// }
import 'dart:convert';
import 'package:events_app_exam/data/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPrefService {
  SharedPreferences? _sharedPreferences;

  Future<void> _initSharedPreferences() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  Future<void> addUser(User user) async {
    await _initSharedPreferences();

    final Map<String, dynamic> userMap = {
      'id': user.id,
      'uid': user.uid,
      'userFCMToken': user.userFCMToken,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'email': user.email,
      'imageUrl': user.imageUrl,
      'favorite-events': jsonEncode(user.favoriteEventsId),
      'registered-events': jsonEncode(user.registeredEventsId),
      'canceled-events': jsonEncode(user.canceledEvents),
    };

    for (var entry in userMap.entries) {
      _sharedPreferences!.setString(entry.key, entry.value);
    }
  }

  Future<String> _getString(String key, [String defaultValue = '']) async {
    await _initSharedPreferences();
    return _sharedPreferences!.getString(key) ?? defaultValue;
  }

  Future<void> _setString(String key, String value) async {
    await _initSharedPreferences();
    _sharedPreferences!.setString(key, value);
  }

  Future<String> getUserId() async => await _getString('id');

  Future<String> getUserUid() async => await _getString('uid');

  Future<String> getUserFCMToken() async => await _getString('userFCMToken');

  Future<String> getUserFirstName() async =>
      await _getString('firstName', 'unnamed');

  Future<String> getUserLastName() async => await _getString('lastName');

  Future<String> getUserEmail() async => await _getString('email');

  Future<String> getUserImageUrl() async => await _getString('imageUrl');

  Future<List<String>> _getEventList(String key) async {
    await _initSharedPreferences();
    final data = _sharedPreferences!.getString(key);
    if (data == null || data.isEmpty) return [];
    return (jsonDecode(data) as List<dynamic>).map((e) => e as String).toList();
  }

  Future<List<String>> getUserFavoriteEvents() async =>
      await _getEventList('favorite-events');

  Future<List<String>> getUserRegisteredEvents() async =>
      await _getEventList('registered-events');

  Future<List<String>> getUserCanceledEvents() async =>
      await _getEventList('canceled-events');

  Future<void> setUserId(String id) async => await _setString('id', id);

  Future<void> setUserUid(String uid) async => await _setString('uid', uid);

  Future<void> setUserFCMToken(String userFCMToken) async =>
      await _setString('userFCMToken', userFCMToken);

  Future<void> setUserFirstName(String firstName) async =>
      await _setString('firstName', firstName);

  Future<void> setUserLastName(String lastName) async =>
      await _setString('lastName', lastName);

  Future<void> setUserEmail(String email) async =>
      await _setString('email', email);

  Future<void> setUserImageUrl(String imageUrl) async =>
      await _setString('imageUrl', imageUrl);

  Future<bool> _addEvent(String key, String eventId) async {
    await _initSharedPreferences();
    List<String> data = await _getEventList(key);
    if (!data.contains(eventId)) {
      data.add(eventId);
      await _sharedPreferences!.setString(key, jsonEncode(data));
      return true;
    }
    return false;
  }

  Future<bool> addRegisteredEvent(String eventId) async =>
      await _addEvent('registered-events', eventId);

  Future<bool> addFavoriteEvent(String eventId) async =>
      await _addEvent('favorite-events', eventId);

  Future<bool> addCanceledEvent(String eventId) async =>
      await _addEvent('canceled-events', eventId);
}

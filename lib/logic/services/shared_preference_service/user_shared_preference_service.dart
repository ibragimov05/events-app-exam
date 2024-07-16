import 'package:events_app_exam/data/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPrefService {
  Future<void> addUser(User user) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    final userMap = {
      'id': user.id,
      'uid': user.uid,
      'userFCMToken': user.userFCMToken,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'email': user.email,
      'imageUrl': user.imageUrl,
    };

    for (var entry in userMap.entries) {
      sharedPreferences.setString(entry.key, entry.value);
    }
  }

  Future<String> _getString(String key, [String defaultValue = '']) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(key) ?? defaultValue;
  }

  Future<void> _setString(String key, String value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(key, value);
  }

  Future<String> getUserId() async => _getString('id');
  Future<String> getUserUid() async => _getString('uid');
  Future<String> getUserFCMToken() async => _getString('userFCMToken');
  Future<String> getUserFirstName() async => _getString('firstName', 'unnamed');
  Future<String> getUserLastName() async => _getString('lastName');
  Future<String> getUserEmail() async => _getString('email');
  Future<String> getUserImageUrl() async => _getString('imageUrl');

  Future<void> setUserId(String id) async => _setString('id', id);
  Future<void> setUserUid(String uid) async => _setString('uid', uid);
  Future<void> setUserFCMToken(String userFCMToken) async => _setString('userFCMToken', userFCMToken);
  Future<void> setUserFirstName(String firstName) async => _setString('firstName', firstName);
  Future<void> setUserLastName(String lastName) async => _setString('lastName', lastName);
  Future<void> setUserEmail(String email) async => _setString('email', email);
  Future<void> setUserImageUrl(String imageUrl) async => _setString('imageUrl', imageUrl);
}

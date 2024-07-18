import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_app_exam/utils/app_colors.dart';
import 'package:events_app_exam/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

class AppFunctions {
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.comicSans,
        ),
      ),
    );
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.comicSans.copyWith(
            color: AppColors.errorRed,
          ),
        ),
      ),
    );
  }

  static String? textValidator(String? text, String fieldName) {
    if (text == null || text.trim().isEmpty) {
      return 'Please, enter your ${fieldName.toLowerCase()}';
    }
    return null;
  }

  static DateTime combineDateTimeAndTimeOfDay(DateTime date, TimeOfDay time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  static String getFormattedDate(Timestamp time) {
    DateTime dateTime = time.toDate();
    DateFormat formatter = DateFormat('MMMM dd, yyyy');
    return formatter.format(dateTime);
  }

  static String getFormattedTimeOfDay(Timestamp time) {
    final date = time.toDate();
    TimeOfDay timeOfDay = TimeOfDay(hour: date.hour, minute: date.minute);
    String formattedHour = timeOfDay.hour.toString().padLeft(2, '0');
    String formattedMinute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$formattedHour:$formattedMinute';
  }

  static Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placeMarks[0];
      return "${place.subLocality}, ${place.street}, ${place.locality}";
    } catch (e) {
      return '';
    }
  }

  String dateTime(Timestamp time) => AppFunctions.getFormattedDate(time);

  String timeOfDay(Timestamp time) => AppFunctions.getFormattedTimeOfDay(time);

  static String convertIntoDay(int day) {
    switch (day) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Invalid day';
    }
  }
}

import 'package:events_app_exam/utils/app_colors.dart';
import 'package:events_app_exam/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

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
      return 'Ilitmos, ${fieldName.toLowerCase()}ingizni kiriting';
    }
    return null;
  }
}

import 'package:events_app_exam/utils/app_colors.dart';
import 'package:events_app_exam/utils/app_text_styles.dart';
import 'package:flutter/widgets.dart';

class CustomMainOrangeButton extends StatelessWidget {
  final String buttonText;
  final void Function() onTap;
  final Color? color;

  const CustomMainOrangeButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: color == null ? AppColors.mainOrange.withOpacity(0.1) : color,
          border: Border.all(
            color: AppColors.mainOrange,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: AppTextStyles.comicSans.copyWith(
              fontSize: 26,
            ),
          ),
        ),
      ),
    );
  }
}

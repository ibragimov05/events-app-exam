import 'package:events_app_exam/utils/app_colors.dart';
import 'package:events_app_exam/utils/app_text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreenTextField extends StatelessWidget {
  final Function() onTuneTap;
  final TextEditingController textEditingController;
  const HomeScreenTextField({
    super.key,
    required this.onTuneTap,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        prefixIcon: IconButton(
          onPressed: () {},
          icon: const Icon(CupertinoIcons.search),
        ),
        suffixIcon: IconButton(
          onPressed: onTuneTap,
          icon: const Icon(Icons.tune),
        ),
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.mainOrange, width: 3),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.mainOrange, width: 3),
        ),
        hintText: 'Tadbirlarni izlash',
        hintStyle: AppTextStyles.comicSans.copyWith(
          color: Colors.grey.withOpacity(0.8),
        ),
      ),
    );
  }
}

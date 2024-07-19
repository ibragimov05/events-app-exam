import 'package:events_app_exam/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String text;
  final String userInfo;
  final void Function() onTap;

  const CustomListTile({
    super.key,
    required this.text,
    required this.userInfo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: AppTextStyles.comicSans),
        Text(userInfo, style: AppTextStyles.comicSans),
        IconButton(
          onPressed: onTap,
          icon: const Icon(Icons.edit),
        ),
      ],
    );
  }
}

import 'package:events_app_exam/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DrawerListTile extends StatelessWidget {
  final IconData drawerIcon;
  final String text;
  final Function() onTap;
  const DrawerListTile({
    super.key,
    required this.drawerIcon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(drawerIcon),
                const Gap(5),
                Text(
                  text,
                  style: AppTextStyles.comicSans.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios_rounded)
          ],
        ),
      ),
    );
  }
}

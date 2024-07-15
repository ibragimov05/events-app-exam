import 'package:events_app_exam/logic/bloc/auth/auth_bloc.dart';
import 'package:events_app_exam/utils/app_colors.dart';
import 'package:events_app_exam/utils/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../utils/app_text_styles.dart';
import 'drawer_list_tile.dart';

class HomeScreenDrawer extends StatelessWidget {
  const HomeScreenDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = context.read<AuthBloc>();
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey, width: 5),
              ),
            ),
            currentAccountPicture:
                const CircleAvatar(backgroundColor: Colors.amber),
            accountName: Text(
              'unnamed',
              style: AppTextStyles.comicSans.copyWith(color: Colors.black),
            ),
            accountEmail: Text(
              'test',
              style: AppTextStyles.comicSans.copyWith(color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                DrawerListTile(
                  draweIcon: Icons.event,
                  text: 'My events',
                  onTap: () => Navigator.pushNamed(context, AppRouter.myEvents),
                ),
                DrawerListTile(
                  draweIcon: Icons.person_outlined,
                  text: 'Profile',
                  onTap: () => Navigator.pushNamed(context, AppRouter.profile),
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => authBloc.add(LogoutUserEvent()),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.logout,
                    color: AppColors.errorRed,
                    size: 28,
                  ),
                  const Gap(10),
                  Text(
                    'Logout',
                    style: AppTextStyles.comicSans.copyWith(
                      color: AppColors.errorRed,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

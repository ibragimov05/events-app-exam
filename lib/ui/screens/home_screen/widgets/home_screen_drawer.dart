import 'package:events_app_exam/logic/bloc/auth/auth_bloc.dart';
import 'package:events_app_exam/logic/bloc/user/user_bloc.dart';
import 'package:events_app_exam/ui/widgets/image_with_loader.dart';
import 'package:events_app_exam/utils/app_colors.dart';
import 'package:events_app_exam/utils/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../utils/app_text_styles.dart';
import 'drawer_list_tile.dart';

class HomeScreenDrawer extends StatefulWidget {
  const HomeScreenDrawer({super.key});

  @override
  State<HomeScreenDrawer> createState() => _HomeScreenDrawerState();
}

class _HomeScreenDrawerState extends State<HomeScreenDrawer> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(FetchUserInfoEvent());
  }

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = context.read<AuthBloc>();
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          BlocBuilder<UserBloc, UserState>(
            buildWhen: (previous, current) =>
                previous != current && current is UserInfoLoadedState,
            builder: (context, state) {
              if (state is UserInfoLoadedState) {
                return UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 5),
                    ),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: state.imageUrl.isEmpty
                        ? const SizedBox()
                        : ImageWithLoader(
                            imageUrl: state.imageUrl, h: 100, w: 100),
                  ),
                  accountName: Text(
                    state.name,
                    style:
                        AppTextStyles.comicSans.copyWith(color: Colors.black),
                  ),
                  accountEmail: Text(
                    state.email,
                    style:
                        AppTextStyles.comicSans.copyWith(color: Colors.black),
                  ),
                );
              }
              if (state is ErrorUserState) {
                return SizedBox(
                  height: 200,
                  child: Center(child: Text(state.error)),
                );
              }
              return const SizedBox.shrink();
            },
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

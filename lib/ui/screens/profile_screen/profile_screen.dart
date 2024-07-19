import 'package:events_app_exam/logic/bloc/user/user_bloc.dart';
import 'package:events_app_exam/ui/screens/profile_screen/widgets/custom_list_tile.dart';
import 'package:events_app_exam/ui/widgets/image_with_loader.dart';
import 'package:events_app_exam/ui/widgets/manage_media.dart';
import 'package:events_app_exam/ui/screens/profile_screen/widgets/show_edit_dialog.dart';
import 'package:events_app_exam/ui/widgets/arrow_back_button.dart';
import 'package:events_app_exam/utils/app_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = context.read<UserBloc>();
    return Scaffold(
      appBar: AppBar(
        leading: const ArrowBackButton(),
        title: const Text('Profile'),
      ),
      body: BlocConsumer<UserBloc, UserState>(
        bloc: context.read<UserBloc>()..add(FetchUserInfoEvent()),
        listener: (context, state) {
          if (state is ErrorUserState) {
            AppFunctions.showErrorSnackBar(context, state.error);
          } else if (state is LoadingUserState) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is UserInfoLoadedState) {
            Navigator.pop(context);
          }
        },
        buildWhen: (UserState previous, UserState current) =>
            previous != current && current is UserInfoLoadedState,
        builder: (BuildContext context, UserState state) {
          if (state is UserInfoLoadedState) {
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => ManageMedia(
                        userId: state.id,
                        isEditProfile: true,
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 200,
                        width: 200,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: state.imageUrl.isEmpty
                            ? const SizedBox()
                            : ImageWithLoader(
                                imageUrl: state.imageUrl, h: 200, w: 200),
                      ),
                    ],
                  ),
                ),
                CustomListTile(
                  text: 'First name',
                  userInfo: state.name,
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => ShowEditDialog(
                      editType: 'name',
                      deafaultValue: state.name,
                      editUserInfo: (p0) {
                        userBloc.add(
                          EditUserNameEvent(
                            id: state.id,
                            newUserName: p0,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                CustomListTile(
                  text: 'Last name',
                  userInfo: state.surname,
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => ShowEditDialog(
                      editType: 'surname',
                      deafaultValue: state.surname,
                      editUserInfo: (p0) {
                        userBloc.add(
                          EditUserSurnameEvent(
                            id: state.id,
                            newUserSurname: p0,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                CustomListTile(
                  text: 'Email',
                  userInfo: state.email,
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('You cannot change your email'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Ok'),
                        ),
                      ],
                    ),
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Language'),
                    Text('ENG'),
                  ],
                ),
                SwitchListTile(
                  title: const Text('Dark mode'),
                  value: false,
                  onChanged: (value) {},
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),

    );
  }
}

import 'package:events_app_exam/logic/bloc/user/user_bloc.dart';
import 'package:events_app_exam/ui/screens/profile_screen/widgets/custom_list_tile.dart';
import 'package:events_app_exam/ui/screens/profile_screen/widgets/edit_user_image.dart';
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
    context.read<UserBloc>().add(FetchUserInfoEvent());
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
        listener: (context, state) {
          if (state is ErrorUserState) {
            AppFunctions.showErrorSnackBar(context, state.error);
          } else if (state is LoadingUserState) {
            showDialog(
              context: context,
              barrierDismissible: false, // To prevent dismissing the dialog
              builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is UserInfoLoadedState) {
            Navigator.pop(context);
          }
        },
        buildWhen: (previous, current) =>
            previous != current && current is UserInfoLoadedState,
        builder: (context, state) {
          if (state is UserInfoLoadedState) {
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => ManageMedia(userId: state.id),
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
                            : Image.network(
                                state.imageUrl,
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child; // Image is fully loaded, display it
                                  } else {
                                    // Display a progress indicator while the image is loading
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  }
                                },
                              ),
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

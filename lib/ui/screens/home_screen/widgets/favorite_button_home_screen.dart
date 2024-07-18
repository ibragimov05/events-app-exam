import 'package:events_app_exam/logic/bloc/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteButtonHomeScreen extends StatefulWidget {
  final String eventId;

  const FavoriteButtonHomeScreen({super.key, required this.eventId});

  @override
  State<FavoriteButtonHomeScreen> createState() =>
      _FavoriteButtonHomeScreenState();
}

class _FavoriteButtonHomeScreenState extends State<FavoriteButtonHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      bloc: context.read<UserBloc>()..add(FetchUserInfoEvent()),
      buildWhen: (previous, current) =>
          previous != current && current is UserInfoLoadedState,
      builder: (BuildContext context, UserState state) {
        if (state is UserInfoLoadedState) {
          return IconButton(
            onPressed: () {
              context.read<UserBloc>().add(
                    AddFavoriteEvent(id: state.id, eventId: widget.eventId),
                  );
            },
            icon: Icon(
              _checkIsFavorite(
                userFavoriteList: state.favoriteEvents,
                eventId: widget.eventId,
              )
                  ? Icons.favorite
                  : Icons.favorite_border,
            ),
          );
        } else {
          return const Icon(Icons.favorite_border);
        }
      },
    );
  }

  bool _checkIsFavorite({
    required List<String> userFavoriteList,
    required String eventId,
  }) {
    for (var element in userFavoriteList) {
      if (element == eventId) {
        return true;
      }
    }
    return false;
  }
}

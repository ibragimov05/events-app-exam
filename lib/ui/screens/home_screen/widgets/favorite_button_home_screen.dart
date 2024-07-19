import 'dart:convert';

import 'package:events_app_exam/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteButtonHomeScreen extends StatefulWidget {
  final String eventId;

  const FavoriteButtonHomeScreen({super.key, required this.eventId});

  @override
  State<FavoriteButtonHomeScreen> createState() =>
      _FavoriteButtonHomeScreenState();
}

class _FavoriteButtonHomeScreenState extends State<FavoriteButtonHomeScreen> {
  late bool _isFav;

  @override
  void initState() {
    super.initState();
    _isFav = _checkIsFavorite(
        userFavoriteList: AppConstants.userFavList, eventId: widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        _isFav = !_isFav;
        SharedPreferences preferences = await SharedPreferences.getInstance();
        if (!_isFav) {
          AppConstants.userFavList
              .removeWhere((element) => element == widget.eventId);
        } else {
          AppConstants.userFavList.add(widget.eventId);
        }
        preferences.setString(
          'favorite-events',
          jsonEncode(AppConstants.userFavList),
        );
        setState(() {});
      },
      icon: Icon(_isFav ? Icons.favorite : Icons.favorite_border),
    );
  }

  bool _checkIsFavorite({
    required List<String> userFavoriteList,
    required String eventId,
  }) {
    for (var each in userFavoriteList) {
      if (eventId == each) {
        return true;
      }
    }
    return false;
  }
}

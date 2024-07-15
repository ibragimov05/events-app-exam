import 'package:events_app_exam/ui/widgets/arrow_back_button.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const ArrowBackButton(),
        title: const Text('Profile'),
      ),
      body: ListView(
        children: const [
          CircleAvatar(
            maxRadius: 100,
            minRadius: 100,
          ),
        ],
      ),
    );
  }
}

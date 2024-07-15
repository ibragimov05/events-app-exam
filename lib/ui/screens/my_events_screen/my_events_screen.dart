import 'package:events_app_exam/ui/widgets/arrow_back_button.dart';
import 'package:flutter/material.dart';

class MyEventsScreen extends StatelessWidget {
  const MyEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const ArrowBackButton(),
        title: const Text('My events'),
      ),
    );
  }
}

import 'package:events_app_exam/ui/screens/home_screen/widgets/home_screen_drawer.dart';
import 'package:events_app_exam/ui/screens/home_screen/widgets/home_screen_text_field.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _eventTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bosh sahifa'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_outlined,
              size: 30,
            ),
          ),
        ],
      ),
      drawer: const HomeScreenDrawer(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        children: [
          HomeScreenTextField(
            onTuneTap: () {},
            textEditingController: _eventTextController,
          ),
        ],
      ),
    );
  }
}

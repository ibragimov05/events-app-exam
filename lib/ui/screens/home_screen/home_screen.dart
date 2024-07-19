import 'package:carousel_slider/carousel_slider.dart';
import 'package:events_app_exam/logic/services/firebase/firebase_event_service.dart';
import 'package:events_app_exam/ui/screens/home_screen/widgets/home_screen_drawer.dart';
import 'package:events_app_exam/ui/screens/home_screen/widgets/seven_day_event.dart';
import 'package:events_app_exam/ui/widgets/event_widget.dart';
import 'package:events_app_exam/utils/app_constants.dart';
import 'package:events_app_exam/utils/app_text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/event.dart';
import '../../../logic/bloc/event/event_bloc.dart';
import '../../../utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseEventService _eventService = FirebaseEventService();
  final TextEditingController _eventTextController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main screen'),
        actions: [
          IconButton(
            onPressed: () async {},
            icon: const Icon(
              Icons.notifications_outlined,
              size: 30,
            ),
          ),
        ],
      ),
      drawer: const HomeScreenDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextField(
              controller: _eventTextController,
              onChanged: (query) {
                _searchQuery = query;
                context.read<EventBloc>().add(LoadEvents(query: query));
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(CupertinoIcons.search),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.tune),
                ),
                border: const OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.mainOrange, width: 3),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.mainOrange, width: 3),
                ),
                hintText: 'Search events',
                hintStyle: AppTextStyles.comicSans.copyWith(
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<EventBloc, EventState>(
              builder: (context, state) {
                if (state is EventLoaded) {
                  return state.events.isNotEmpty
                      ? ListView.builder(
                          itemCount: state.events.length,
                          itemBuilder: (context, index) => EventWidget(
                            isHomeScreen: true,
                            event: state.events[index],
                          ),
                        )
                      : const Center(child: Text('No events found'));
                } else {
                  return Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Events that are upcoming in seven days',
                          style: AppTextStyles.comicSans,
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: StreamBuilder(
                          stream: _eventService
                              .getSevenDayEvents(AppConstants.userLocationName),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (!snapshot.hasData || snapshot.hasError) {
                              return Center(
                                child:
                                    Text('error snapshot: ${snapshot.error}'),
                              );
                            } else {
                              List<Event> data = [];
                              if (snapshot.data != null) {
                                data = snapshot.data!;
                              }
                              return data.isNotEmpty
                                  ? CarouselSlider(
                                      options: CarouselOptions(),
                                      items: List.generate(
                                        data.length,
                                        (index) =>
                                            SevenDayEvent(event: data[index]),
                                      ),
                                    )
                                  : const Center(
                                      child: Text(
                                        'No events available that is upcoming in seven days',
                                      ),
                                    );
                            }
                          },
                        ),
                      ),
                      StreamBuilder(
                        stream: _searchQuery.isEmpty
                            ? _eventService
                                .getEvents(AppConstants.userLocationName)
                            : _eventService.searchEvents(_searchQuery),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (!snapshot.hasData || snapshot.hasError) {
                            return Center(
                              child: Text('error: snapshot ${snapshot.error}'),
                            );
                          } else {
                            List<Event> data = [];
                            if (snapshot.data != null) {
                              data = snapshot.data!;
                            }
                            return data.isNotEmpty
                                ? Expanded(
                                    child: ListView.builder(
                                      itemCount: data.length,
                                      itemBuilder: (context, index) {
                                        return EventWidget(
                                          isHomeScreen: true,
                                          event: data[index],
                                        );
                                      },
                                    ),
                                  )
                                : const Center(
                                    child: Text('no events found in your city'),
                                  );
                          }
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:events_app_exam/logic/services/location/location_service.dart';
import 'package:events_app_exam/ui/widgets/arrow_back_button.dart';
import 'package:events_app_exam/ui/widgets/custom_text_form_field.dart';
import 'package:events_app_exam/ui/widgets/manage_media.dart';
import 'package:events_app_exam/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../widgets/error_dialog.dart';

class AddEventsScreen extends StatefulWidget {
  const AddEventsScreen({super.key});

  @override
  State<AddEventsScreen> createState() => _AddEventsScreenState();
}

class _AddEventsScreenState extends State<AddEventsScreen> {
  TimeOfDay _timeOfDay = const TimeOfDay(hour: 0, minute: 0);
  DateTime _dateTime = DateTime.now();
  String _imageUrl = '';
  Point? _userCurrentPosition;
  final TextEditingController _eNameController = TextEditingController();
  final TextEditingController _eDescriptionController = TextEditingController();
  YandexMapController? _yandexMapController;
  bool _isFetchingAddress = true;
  List<MapObject>? _polyLines;
  final TextEditingController _searchTextController = TextEditingController();
  List _suggestionList = [];

  void _onMyLocationTapped() {
    if (_userCurrentPosition != null || _yandexMapController != null) {
      _yandexMapController!.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _userCurrentPosition!, zoom: 17),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    LocationService.determinePosition().then(
      (value) async {
        if (value != null) {
          _userCurrentPosition = Point(
            latitude: value.latitude,
            longitude: value.longitude,
          );
        }
      },
    ).catchError((error) {
      showDialog(
        context: context,
        builder: (context) => ShowErrorDialog(errorText: error.toString()),
      );
    }).whenComplete(
      () {
        _isFetchingAddress = false;
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const ArrowBackButton(),
        title: const Text('Add event'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                CustomTextFormField(
                  hintText: 'Name',
                  isObscure: false,
                  validator: (p0) => null,
                  textEditingController: _eNameController,
                  isMaxLines: true,
                ),
                const Gap(15),
                CustomTextFormField(
                  hintText: 'Description about event',
                  isObscure: false,
                  validator: (p0) => null,
                  textEditingController: _eDescriptionController,
                  isMaxLines: true,
                ),
                const Gap(15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FilledButton.icon(
                      icon: const Icon(Icons.date_range),
                      onPressed: () async {
                        final DateTime? chosenDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 30)),
                        );
                        if (chosenDate != null) {
                          setState(() {
                            _dateTime = chosenDate;
                          });
                        }
                      },
                      label: const Text('Date'),
                    ),
                    FilledButton.icon(
                      icon: const Icon(Icons.access_time_rounded),
                      onPressed: () async {
                        final TimeOfDay? chosenTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (chosenTime != null) {
                          setState(() {
                            _timeOfDay = chosenTime;
                          });
                        }
                      },
                      label: const Text('Time'),
                    ),
                    FilledButton.icon(
                      icon: const Icon(Icons.picture_in_picture_rounded),
                      onPressed: () async {
                        final String? imageUrl = await showDialog(
                          context: context,
                          builder: (context) =>
                              const ManageMedia(isEditProfile: false),
                        );
                        if (imageUrl != null) {
                          setState(() {
                            _imageUrl = imageUrl;
                          });
                        }
                      },
                      label: const Text('Picture'),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose location',
                  style: AppTextStyles.comicSans.copyWith(fontSize: 20),
                ),
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 2,
                  child: Stack(
                    children: [
                      YandexMap(
                        onMapCreated: (controller) async {
                          _yandexMapController = controller;
                        },
                        mapType: MapType.vector,
                        onMapTap: (Point point) {},
                        zoomGesturesEnabled: true,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: FloatingActionButton(
                            backgroundColor: const Color(0xFF1C1D22),
                            onPressed: _onMyLocationTapped,
                            child: const Icon(
                              Icons.navigation_outlined,
                              color: Color(0xFFCCCCCC),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _eNameController.dispose();
    _eDescriptionController.dispose();
    super.dispose();
  }
}

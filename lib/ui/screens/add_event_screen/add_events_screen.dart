import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_app_exam/logic/services/firebase/firebase_event_service.dart';
import 'package:events_app_exam/logic/services/shared_preference_service/user_shared_preference_service.dart';
import 'package:events_app_exam/ui/screens/add_event_screen/widgets/yandex_map_widget.dart';
import 'package:events_app_exam/ui/widgets/arrow_back_button.dart';
import 'package:events_app_exam/ui/widgets/custom_text_form_field.dart';
import 'package:events_app_exam/ui/widgets/manage_media.dart';
import 'package:events_app_exam/utils/app_colors.dart';
import 'package:events_app_exam/utils/app_functions.dart';
import 'package:events_app_exam/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class AddEventsScreen extends StatefulWidget {
  const AddEventsScreen({super.key});

  @override
  State<AddEventsScreen> createState() => _AddEventsScreenState();
}

class _AddEventsScreenState extends State<AddEventsScreen> {
  TimeOfDay? _timeOfDay;
  DateTime? _dateTime;
  String? _imageUrl;

  final FirebaseEventService _eventService = FirebaseEventService();

  Point? _eventLocation;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _eNameController = TextEditingController();
  final TextEditingController _eDescriptionController = TextEditingController();

  void _onSaveTap() async {
    if (_formKey.currentState!.validate() &&
        _dateTime != null &&
        _timeOfDay != null &&
        _imageUrl != null &&
        _eventLocation != null) {
      final String userID = await UserSharedPrefService().getUserId();
      try {
        _eventService.addEvent(
          creatorId: userID,
          name: _eNameController.text,
          time: Timestamp.fromDate(
            AppFunctions.combineDateTimeAndTimeOfDay(_dateTime!, _timeOfDay!),
          ),
          geoPoint:
              GeoPoint(_eventLocation!.latitude, _eventLocation!.longitude),
          description: _eDescriptionController.text,
          imageUrl: _imageUrl!,
        );
        if (mounted) {
          Navigator.of(context).pop();

          AppFunctions.showSnackBar(
            context,
            'New event has been added successully',
          );
        }
      } catch (e) {
        if (mounted) {
          AppFunctions.showErrorSnackBar(context, e.toString());
        }
      }
    } else {
      AppFunctions.showSnackBar(context, 'Please fill all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        hintText: 'Event name',
                        isObscure: false,
                        validator: (p0) =>
                            AppFunctions.textValidator(p0, 'event name'),
                        textEditingController: _eNameController,
                        isMaxLines: true,
                      ),
                      const Gap(15),
                      CustomTextFormField(
                        hintText: 'Description about event',
                        isObscure: false,
                        validator: (p0) => AppFunctions.textValidator(
                            p0, 'description about event'),
                        textEditingController: _eDescriptionController,
                        isMaxLines: true,
                      ),
                      const Gap(15),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FilledButton.icon(
                      icon: const Icon(Icons.date_range),
                      onPressed: () async {
                        final DateTime? chosenDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now().add(
                            const Duration(days: 1),
                          ),
                          lastDate: DateTime.now().add(
                            const Duration(days: 30),
                          ),
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
                          barrierDismissible: false,
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
                  child: YandexMapWidget(
                    onLocationTap: (Point p0) {
                      _eventLocation = p0;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: _onSaveTap,
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.mainOrange,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
              child: Text(
            'Save',
            style: AppTextStyles.comicSans.copyWith(fontSize: 18),
          )),
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

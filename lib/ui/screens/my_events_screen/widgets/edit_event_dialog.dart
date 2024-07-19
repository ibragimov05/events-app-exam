import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_app_exam/data/models/event.dart';
import 'package:events_app_exam/logic/services/firebase/firebase_event_service.dart';
import 'package:events_app_exam/ui/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class EditEventDialog extends StatefulWidget {
  final Event event;

  const EditEventDialog({super.key, required this.event});

  @override
  State<EditEventDialog> createState() => _EditEventDialogState();
}

class _EditEventDialogState extends State<EditEventDialog> {
  final TextEditingController _eNameC = TextEditingController();
  final TextEditingController _eDescriptionC = TextEditingController();
  final TextEditingController _eLocationNameC = TextEditingController();
  final TextEditingController _eImageUrlC = TextEditingController();
  final TextEditingController _eStartTimeC = TextEditingController();
  final TextEditingController _eEndTimeC = TextEditingController();
  final FirebaseEventService _eventService = FirebaseEventService();

  @override
  void initState() {
    super.initState();
    _eNameC.text = widget.event.name;
    _eDescriptionC.text = widget.event.description;
    _eLocationNameC.text = widget.event.locationName;
    _eImageUrlC.text = widget.event.imageUrl;
    _eStartTimeC.text =
        DateFormat.yMd().add_jm().format(widget.event.startTime.toDate());
    _eEndTimeC.text =
        DateFormat.yMd().add_jm().format(widget.event.endTime.toDate());
  }

  Future<void> _selectDateTime(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (pickedDate != null) {
      if (context.mounted) {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          final DateTime finalDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          setState(() {
            controller.text = DateFormat.yMd().add_jm().format(finalDateTime);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit event'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFormField(
              hintText: 'Event Name',
              isObscure: false,
              validator: (p0) => null,
              textEditingController: _eNameC,
            ),
            const Gap(10),
            CustomTextFormField(
              hintText: 'Description',
              isObscure: false,
              validator: (p0) => null,
              textEditingController: _eDescriptionC,
            ),
            const Gap(10),
            CustomTextFormField(
              hintText: 'Location Name',
              isObscure: false,
              validator: (p0) => null,
              textEditingController: _eLocationNameC,
            ),
            const Gap(10),
            CustomTextFormField(
              hintText: 'Image URL',
              isObscure: false,
              validator: (p0) => null,
              textEditingController: _eImageUrlC,
            ),
            const Gap(10),
            GestureDetector(
              onTap: () => _selectDateTime(context, _eStartTimeC),
              child: AbsorbPointer(
                child: CustomTextFormField(
                  hintText: 'Start Time',
                  isObscure: false,
                  validator: (p0) => null,
                  textEditingController: _eStartTimeC,
                ),
              ),
            ),
            const Gap(10),
            GestureDetector(
              onTap: () => _selectDateTime(context, _eEndTimeC),
              child: AbsorbPointer(
                child: CustomTextFormField(
                  hintText: 'End Time',
                  isObscure: false,
                  validator: (p0) => null,
                  textEditingController: _eEndTimeC,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('cancel'),
        ),
        TextButton(
          onPressed: () {
            final DateTime? startTime = _eStartTimeC.text.isNotEmpty
                ? DateFormat.yMd().add_jm().parse(_eStartTimeC.text)
                : null;
            final DateTime? endTime = _eEndTimeC.text.isNotEmpty
                ? DateFormat.yMd().add_jm().parse(_eEndTimeC.text)
                : null;

            _eventService.editEvent(
              id: widget.event.id,
              name: _eNameC.text,
              startTime:
                  startTime != null ? Timestamp.fromDate(startTime) : null,
              endTime: endTime != null ? Timestamp.fromDate(endTime) : null,
              description: _eDescriptionC.text,
              imageUrl: _eImageUrlC.text,
              locationName: _eLocationNameC.text,
            );
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _eNameC.dispose();
    _eDescriptionC.dispose();
    _eLocationNameC.dispose();
    _eImageUrlC.dispose();
    _eStartTimeC.dispose();
    _eEndTimeC.dispose();
    super.dispose();
  }
}

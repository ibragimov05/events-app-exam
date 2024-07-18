import 'package:events_app_exam/data/models/event.dart';
import 'package:events_app_exam/ui/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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

  @override
  void initState() {
    super.initState();
    _eNameC.text = widget.event.name;
    _eDescriptionC.text = widget.event.description;
    _eLocationNameC.text = widget.event.locationName;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit event'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextFormField(
            hintText: '',
            isObscure: false,
            validator: (p0) => null,
            textEditingController: _eNameC,
          ),
          const Gap(10),
          CustomTextFormField(
            hintText: '',
            isObscure: false,
            validator: (p0) => null,
            textEditingController: _eDescriptionC,
          ),
          const Gap(10),
          CustomTextFormField(
            hintText: '',
            isObscure: false,
            validator: (p0) => null,
            textEditingController: _eLocationNameC,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('cancel'),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('Save'),
        ),
      ],
    );
  }
}

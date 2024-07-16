import 'package:events_app_exam/logic/bloc/user/user_bloc.dart';
import 'package:events_app_exam/utils/app_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowEditDialog extends StatefulWidget {
  final void Function(String) editUserInfo;
  final String editType;
  final String deafaultValue;

  const ShowEditDialog({
    super.key,
    required this.editUserInfo,
    required this.editType,
    required this.deafaultValue,
  });

  @override
  State<ShowEditDialog> createState() => _ShowEditDialogState();
}

class _ShowEditDialogState extends State<ShowEditDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();

  void _onSaveTap() async {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop();
      widget.editUserInfo(_textEditingController.text);
    }
  }

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.deafaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserInfoLoadedState) {
          Navigator.of(context).pop();
        }
      },
      child: AlertDialog(
        title: Text('Editing ${widget.editType}'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _textEditingController,
            validator: (value) =>
                AppFunctions.textValidator(value, widget.editType),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('cancel'),
          ),
          TextButton(
            onPressed: () => _onSaveTap(),
            child: const Text('save'),
          ),
        ],
      ),
    );
  }
}

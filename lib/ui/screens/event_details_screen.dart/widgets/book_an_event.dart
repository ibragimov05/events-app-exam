import 'package:events_app_exam/data/models/event.dart';
import 'package:events_app_exam/logic/services/shared_preference_service/user_shared_preference_service.dart';
import 'package:events_app_exam/ui/screens/event_details_screen.dart/widgets/increment_decrement.dart';
import 'package:events_app_exam/ui/screens/event_details_screen.dart/widgets/payment_selection_widget.dart';
import 'package:events_app_exam/ui/widgets/custom_main_orange_button.dart';
import 'package:events_app_exam/ui/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/bloc/user/user_bloc.dart';

class BookAnEvent extends StatefulWidget {
  final Event _event;

  const BookAnEvent({
    super.key,
    required Event event,
  }) : _event = event;

  @override
  State<BookAnEvent> createState() => _BookAnEventState();
}

class _BookAnEventState extends State<BookAnEvent> {
  int _participatingPeople = 0;
  String _paymentMethod = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 1.5,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          )),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              const Text('register'),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close),
              )
            ],
          ),
          const Text('Add people'),
          IncrementDecrementWidget(
            getNumber: (p0) => _participatingPeople = p0,
          ),
          PaymentSelectionWidget(
            paymentMethod: (p0) => _paymentMethod = p0,
          ),
          BlocConsumer<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserInfoLoadedState) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Successfully registered'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Ok'),
                      )
                    ],
                  ),
                );
              } else if (state is LoaededWithoutAddingState) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Already registered'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Ok'),
                      )
                    ],
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is UserInfoLoadedState ||
                  state is LoaededWithoutAddingState) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CustomMainOrangeButton(
                    buttonText: 'Next',
                    onTap: () async {
                      if (_participatingPeople != 0 && _paymentMethod != '') {
                        context.read<UserBloc>().add(
                              AddNewParticipatingEvent(
                                userId:
                                    await UserSharedPrefService().getUserId(),
                                eventId: widget._event.id,
                              ),
                            );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => const ShowErrorDialog(
                              errorText: 'Please fill all fields'),
                        );
                      }
                    },
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}

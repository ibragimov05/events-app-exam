import 'package:events_app_exam/logic/bloc/auth/auth_bloc.dart';
import 'package:events_app_exam/ui/widgets/arrow_back_button.dart';
import 'package:events_app_exam/ui/widgets/custom_main_orange_button.dart';
import 'package:events_app_exam/ui/widgets/custom_text_form_field.dart';
import 'package:events_app_exam/utils/app_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = context.read<AuthBloc>();
    return Scaffold(
      appBar: AppBar(
        leading: const ArrowBackButton(),
        title: const Text('Parolni tiklash'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(
                'assets/images/tadbiro_logo.svg',
                height: 190,
                width: 190,
                fit: BoxFit.cover,
              ),
              Form(
                key: _formKey,
                child: CustomTextFormField(
                  hintText: 'Emailinigizni kiriting',
                  isObscure: false,
                  validator: (p0) => AppFunctions.textValidator(p0, 'email'),
                  textEditingController: _emailTextController,
                ),
              ),
              BlocConsumer<AuthBloc, AuthStates>(
                listener: (context, state) {
                  if (state is LoadedAuthState) {
                    Navigator.of(context).pop();
                    AppFunctions.showSnackBar(
                      context,
                      'Emailingizga yuborilgan link orqali parolingizni tiklashingiz mumkin',
                    );
                  }
                },
                builder: (context, state) {
                  if (state is LoadingAuthState) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return CustomMainOrangeButton(
                    buttonText: 'Parolni tiklash',
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        authBloc.add(
                          ResetUserPasswordEvent(
                              email: _emailTextController.text),
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

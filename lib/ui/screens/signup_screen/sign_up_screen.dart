import 'package:events_app_exam/logic/bloc/auth/auth_bloc.dart';
import 'package:events_app_exam/ui/widgets/custom_main_orange_button.dart';
import 'package:events_app_exam/ui/widgets/custom_text_form_field.dart';
import 'package:events_app_exam/utils/app_functions.dart';
import 'package:events_app_exam/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:flutter/scheduler.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameTextController =
      TextEditingController();
  final TextEditingController _secondNameTextController =
      TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _confirmPasswordTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = context.read<AuthBloc>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  'assets/images/tadbiro_logo.svg',
                  height: 170,
                  width: 170,
                  fit: BoxFit.cover,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'Ro\'yxatdan o\'tish',
                        style: AppTextStyles.comicSans.copyWith(fontSize: 25),
                      ),
                      const Gap(15),
                      //! first name
                      CustomTextFormField(
                        hintText: 'First name',
                        isObscure: false,
                        validator: (p0) =>
                            AppFunctions.textValidator(p0, 'First name'),
                        textEditingController: _firstNameTextController,
                      ),
                      const Gap(15),

                      //! last name
                      CustomTextFormField(
                        hintText: 'Last name',
                        isObscure: false,
                        validator: (p0) =>
                            AppFunctions.textValidator(p0, 'Last name'),
                        textEditingController: _secondNameTextController,
                      ),
                      const Gap(15),
                      //! email text field
                      CustomTextFormField(
                        hintText: 'Email',
                        isObscure: false,
                        validator: (p0) =>
                            AppFunctions.textValidator(p0, 'Email'),
                        textEditingController: _emailTextController,
                      ),
                      const Gap(15),

                      //! password text field
                      CustomTextFormField(
                        hintText: 'Parol',
                        isObscure: true,
                        validator: (p0) =>
                            AppFunctions.textValidator(p0, 'Parol'),
                        textEditingController: _passwordTextController,
                      ),
                      const Gap(15),

                      //! confirm password text field
                      CustomTextFormField(
                        hintText: 'Parolni tasdiqlang',
                        isObscure: true,
                        validator: (p0) {
                          if (_confirmPasswordTextController.text !=
                              _passwordTextController.text) {
                            return 'Parol, bir hil bo\'lishi kerak';
                          }
                          return null;
                        },
                        textEditingController: _confirmPasswordTextController,
                      ),
                      const Gap(15),

                      BlocConsumer<AuthBloc, AuthStates>(
                        listener: (BuildContext context, AuthStates state) {
                          if (state is LoadedAuthState) {
                            Navigator.of(context).pop();
                          } else if (state is ErrorAuthState) {
                            AppFunctions.showErrorSnackBar(
                              context,
                              'error: ${state.errorMessage}',
                            );
                            Navigator.of(context).pop();
                          }
                        },
                        builder: (BuildContext context, AuthStates state) {
                          if (state is LoadingAuthState) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return CustomMainOrangeButton(
                            buttonText: 'Register',
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                authBloc.add(
                                  RegisterUserEvent(
                                    firstName: _firstNameTextController.text,
                                    lastName: _secondNameTextController.text,
                                    email: _emailTextController.text,
                                    password: _passwordTextController.text,
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Gap(15),
                BlocBuilder<AuthBloc, AuthStates>(
                  builder: (BuildContext context, AuthStates state) {
                    if (state is LoadingAuthState) {
                      return const SizedBox();
                    } else {
                      return GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'Register',
                          style: AppTextStyles.comicSans.copyWith(fontSize: 22),
                        ),
                      );
                    }
                  },
                ),
                BlocListener<AuthBloc, AuthStates>(
                  listener: (context, state) {
                    if (state is ErrorAuthState) {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.errorMessage)),
                        );
                      });
                    }
                  },
                  child: const SizedBox(),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameTextController.dispose();
    _secondNameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _confirmPasswordTextController.dispose();
    super.dispose();
  }
}

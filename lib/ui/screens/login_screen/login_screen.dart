import 'package:events_app_exam/logic/bloc/auth/auth_bloc.dart';
import 'package:events_app_exam/ui/widgets/custom_main_orange_button.dart';
import 'package:events_app_exam/ui/widgets/custom_text_form_field.dart';
import 'package:events_app_exam/utils/app_functions.dart';
import 'package:events_app_exam/utils/app_router.dart';
import 'package:events_app_exam/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:flutter/scheduler.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = context.read<AuthBloc>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                'assets/images/tadbiro_logo.svg',
                height: 190,
                width: 190,
                fit: BoxFit.cover,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      'Tizimga kirish',
                      style: AppTextStyles.comicSans.copyWith(fontSize: 25),
                    ),
                    const Gap(20),
                    CustomTextFormField(
                      hintText: 'Email',
                      isObscure: false,
                      validator: (p0) =>
                          AppFunctions.textValidator(p0, 'Email'),
                      textEditingController: _emailTextController,
                    ),
                    const Gap(20),
                    CustomTextFormField(
                      hintText: 'Parol',
                      isObscure: true,
                      validator: (p0) =>
                          AppFunctions.textValidator(p0, 'Parol'),
                      textEditingController: _passwordTextController,
                    ),
                    const Gap(20),
                    BlocBuilder<AuthBloc, AuthStates>(
                      builder: (context, state) {
                        if (state is LoadingAuthState) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return CustomMainOrangeButton(
                          buttonText: 'Kirish',
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              authBloc.add(
                                LoginUserEvent(
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
              BlocBuilder<AuthBloc, AuthStates>(
                builder: (context, state) {
                  if (state is LoadingAuthState) {
                    return const SizedBox();
                  } else {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, AppRouter.signUp),
                          child: Text(
                            'Ro\'yxatdan o\'tish',
                            style:
                                AppTextStyles.comicSans.copyWith(fontSize: 22),
                          ),
                        ),
                        const Gap(10),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, AppRouter.passwordRecovery),
                          child: Text(
                            'Parolni tiklash',
                            style:
                                AppTextStyles.comicSans.copyWith(fontSize: 22),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              BlocListener<AuthBloc, AuthStates>(
                listener: (context, state) {
                  if (state is ErrorAuthState) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      AppFunctions.showErrorSnackBar(
                          context, state.errorMessage);
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
    );
  }
}

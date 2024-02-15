import 'package:firebase_integration/login/forgot_password/cubit/forgot_password_cubit.dart';
import 'package:firebase_integration/login/forgot_password/screen/reset_password_screen.dart';
import 'package:firebase_integration/utils/snackbar.dart';
import 'package:firebase_integration/widget/custom_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  static const routeName = '/forgotPassword';

  static Route<void> route(RouteSettings settings) {
    return MaterialPageRoute(
        builder: (context) => BlocProvider(
            create: (context) => ForgotPasswordCubit(),
            child: const ForgotPasswordScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final forgotPasswordCubit = context.read<ForgotPasswordCubit>();
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          Navigator.pushNamed(context, ResetPasswordScreen.routeName);
        }
        if (state is ForgotPasswordFailure) {
          showErrorSnackBar(context: context, message: state.message);
        }
      },
      builder: (context, state) {
        return state is ForgotPasswordLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              )
            : Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Forgot Your Password?',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                          'Enter your email and we will send you a instruction to reset your password'),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: forgotPasswordCubit.formKey,
                          child: CustomTextField(
                            controller: forgotPasswordCubit.email,
                            hintText: 'Enter email',
                            prefixIcon: const Icon(Icons.email),
                            obscure: false,
                            validator: (email) {
                              if (email == null || email == '') {
                                return 'please enter email';
                              } else if (!RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                              ).hasMatch(email)) {
                                return 'please enter valid email';
                              }
                              return null;
                              // Validation().emailValidation(email);
                              // return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (forgotPasswordCubit.formKey.currentState!
                              .validate()) {
                            forgotPasswordCubit.sendPasswordResetEmail();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Submit'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}

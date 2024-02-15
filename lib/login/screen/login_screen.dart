import 'package:firebase_integration/home/screen/home_screen.dart';
import 'package:firebase_integration/login/cubit/login_cubit.dart';
import 'package:firebase_integration/login/email_verification/screen/email_verification_screen.dart';
import 'package:firebase_integration/login/forgot_password/screen/forgot_password_screen.dart';
import 'package:firebase_integration/signup/screen/signup_screen.dart';
import 'package:firebase_integration/utils/snackbar.dart';
import 'package:firebase_integration/widget/custom_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const routeName = '/LoginPage';

  static Route<void> route(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => BlocProvider(
          create: (context) => LoginCubit(), child: const LoginPage()),
    );
  }

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    final loginCubit = context.read<LoginCubit>();

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          // showSuccessSnackBar(context: context, message: state.message);
          Navigator.pushNamed(context, EmailVerificationScreen.routeName);
        }
        if (state is LoginFailure) {
          // showErrorSnackBar(context: context, message: state.message);
        }
      },
      builder: (_, state) {
        return state is LoginLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              )
            : Scaffold(
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: loginCubit.formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextField(
                            controller: loginCubit.email,
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
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                              controller: loginCubit.password,
                              hintText: 'Enter password',
                              prefixIcon: const Icon(Icons.password),
                              obscure: hidePassword,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                                icon: Icon(hidePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                              validator: (password) {
                                if (password == null || password == '') {
                                  return 'please enter password';
                                } else if (password.length < 8) {
                                  return 'password length is low';
                                }
                                return null;
                                // Validation.passwordValidation(password);
                                // return null;
                              }),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (loginCubit.formKey.currentState!
                                        .validate()) {
                                      loginCubit.loginWithUserCredential();
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.greenAccent),
                                    child: const Center(
                                        child: Text(
                                      'Login',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, SignUpPage.routeName);
                                    },
                                    child: const Text('SingUp')),
                              )),
                          Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          ForgotPasswordScreen.routeName);
                                    },
                                    child: const Text('Forgot password')),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }
}

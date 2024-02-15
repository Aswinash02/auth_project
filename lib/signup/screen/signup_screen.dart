import 'package:firebase_integration/login/screen/login_screen.dart';
import 'package:firebase_integration/signup/cubit/signup_cubit.dart';
import 'package:firebase_integration/utils/snackbar.dart';
import 'package:firebase_integration/widget/custom_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  static const routeName = '/SignUpPage';

  static Route route(RouteSettings settings) {
    return MaterialPageRoute(
        settings: settings,
        builder: (context) => BlocProvider(
            create: (context) => SignupCubit(), child: const SignUpPage()));
  }

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    final signUpCubit = context.read<SignupCubit>();
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupFailure) {
          showErrorSnackBar(context: context, message: state.message);
        }
        if (state is SignupSuccess) {
          Navigator.pushNamed(context, LoginPage.routeName);
          showSuccessSnackBar(context: context, message: state.message);
        }
      },
      builder: (context, state) {
        return state is SignupLoading
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
                      key: signUpCubit.signUpFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextField(
                            controller: signUpCubit.name,
                            hintText: 'Enter Name',
                            prefixIcon: const Icon(Icons.person),
                            obscure: false,
                            validator: (password) {
                              if (password == null || password == '') {
                                return 'please enter name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            controller: signUpCubit.email,
                            hintText: 'Enter email',
                            prefixIcon: const Icon(Icons.email),
                            obscure: false,
                            validator: (email) {
                              // Validation().emailValidation(email);
                              if (email == null || email == '') {
                                return 'please enter email';
                              } else if (!RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                              ).hasMatch(email)) {
                                return 'please enter valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            controller: signUpCubit.password,
                            hintText: 'Enter password',
                            prefixIcon: const Icon(Icons.password),
                            obscure: hidePassword,
                            suffixIcon: IconButton(
                              icon: Icon(hidePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                            ),
                            validator: (password) {
                              if (password == null || password == '') {
                                return 'please enter password';
                              } else if (password.length < 8) {
                                return 'password length is low';
                              }
                              return null;
                              // Validation.passwordValidation(password);
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            controller: signUpCubit.confirmPassword,
                            hintText: 'Enter confirm password',
                            prefixIcon: const Icon(Icons.password),
                            obscure: hidePassword,
                            suffixIcon: IconButton(
                              icon: Icon(hidePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                            ),
                            validator: (confirmPassword) {
                              if (confirmPassword == null ||
                                  confirmPassword == '') {
                                return 'please enter confirmPassword';
                              } else if (confirmPassword !=
                                  signUpCubit.password.text) {
                                return 'enter correct password';
                              }
                              return null;
                              // Validation.confirmPasswordValidation(
                              //     confirmPassword, signUpCubit.password.text);
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (signUpCubit.signUpFormKey.currentState!
                                        .validate()) {
                                      signUpCubit
                                          .createUserWithEmailAndPassword();
                                    }

                                    // Navigator.pushNamed(context, LoginPage.routeName);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.greenAccent),
                                    child: const Center(
                                        child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                ),
                              ),
                            ],
                          )
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

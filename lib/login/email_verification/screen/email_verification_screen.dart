import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_integration/home/screen/home_screen.dart';
import 'package:firebase_integration/login/cubit/login_cubit.dart';
import 'package:firebase_integration/login/email_verification/cubit/email_verification_cubit.dart';
import 'package:firebase_integration/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  static const routeName = '/emailVerification';

  static Route<void> route(RouteSettings settings) {
    return MaterialPageRoute(
        builder: (context) => BlocProvider(
            create: (context) => EmailVerificationCubit(),
            child: const EmailVerificationScreen()));
  }

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  @override
  void initState() {
    final emailVerificationCubit = context.read<EmailVerificationCubit>();
    emailVerificationCubit.sendEmailVerification();
    // emailVerificationCubit.setTimeForAutoRedirect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final emailVerificationCubit = context.read<EmailVerificationCubit>();
    final auth = FirebaseAuth.instance.currentUser;
    return BlocConsumer<EmailVerificationCubit, EmailVerificationState>(
      listener: (context, state) {
        if (state is EmailVerificationFailure) {
          showErrorSnackBar(context: context, message: state.message);
        }
        if (state is EmailVerificationSuccess) {
          Navigator.pushReplacementNamed(context, HomePage.routeName);
          showSuccessSnackBar(context: context, message: state.message);
        }
      },
      builder: (context, state) {
        return state is EmailVerificationLoading
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
                        'Verify Your Email Address!',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(auth!.email.toString()),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                          onTap: () {
                            emailVerificationCubit.checkEmailVerify();
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(8)),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                child: Text('Confirm'),
                              ))),
                      const SizedBox(
                        height: 8,
                      ),
                      GestureDetector(
                          onTap: () {
                            emailVerificationCubit.sendEmailVerification();
                          },
                          child: const Text('Send Email')),
                    ],
                  ),
                ),
              );
      },
    );
  }
}

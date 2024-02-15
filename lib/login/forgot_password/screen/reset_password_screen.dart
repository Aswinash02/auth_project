import 'package:firebase_integration/login/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/forgot_password_cubit.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  static const routeName = '/resetPassword';

  static Route<void> route(RouteSettings settings) {
    return MaterialPageRoute(
        builder: (context) => BlocProvider(
            create: (context) => ForgotPasswordCubit(),
            child: const ResetPasswordScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final forgotPasswordCubit = context.read<ForgotPasswordCubit>();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Password Reset Email',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(forgotPasswordCubit.state.email),
            const SizedBox(
              height: 10,
            ),
            const Center(
              child: Text(
                  'Your Account security  is our priority! We will send you a secure '
                  'link to safety change your password and keep your account privacy '),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, LoginPage.routeName);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Done'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_integration/authentication/cubit/auth_cubit.dart';
import 'package:firebase_integration/authentication/widget/custom_circularprogress.dart';
import 'package:firebase_integration/authentication/widget/custom_text.dart';
import 'package:firebase_integration/common/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordForm extends StatelessWidget {
  const ResetPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Password Reset Email',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(authCubit.state.loginEmail),
        const SizedBox(
          height: 10,
        ),
        const Center(
          child: Text(
              'Your Account security  is our priority! We will send you a secure '
              'link to safety change your password and keep your account privacy '),
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            authCubit.selectAuthScreen(AuthScreen.login);
          },
          child: Container(
            width: 450,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: AppColors.greenAccentColor,
            ),
            child: Center(
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return state is LoginLoading
                      ? customCircularProgressIndicator()
                      : const CustomText(text: 'Done', size: 16);
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomText(
                text: "Go to Login Page?", fontWeight: FontWeight.w500),
            const SizedBox(
              width: 4,
            ),
            GestureDetector(
                onTap: () {
                  authCubit.selectAuthScreen(AuthScreen.login);
                },
                child: const CustomText(
                    text: "Login",
                    size: 16,
                    color: AppColors.greenAccentColor)),
          ],
        ),
      ],
    );
  }
}

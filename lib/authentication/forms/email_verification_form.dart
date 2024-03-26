import 'package:firebase_integration/authentication/cubit/auth_cubit.dart';
import 'package:firebase_integration/authentication/widget/custom_text.dart';
import 'package:firebase_integration/common/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailVerificationForm extends StatefulWidget {
  const EmailVerificationForm({super.key});

  @override
  State<EmailVerificationForm> createState() => _EmailVerificationFormState();
}

class _EmailVerificationFormState extends State<EmailVerificationForm> {
  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomText(
          text: 'Verify your email address',
          size: 18,
        ),
        const SizedBox(
          height: 20,
        ),
        const CustomText(
          text: 'A verification email has been sent to your email ',
          size: 15,
          fontWeight: FontWeight.w400,
        ),
        CustomText(
          text: '${authCubit.state.signUpEmail} ',
          size: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.greenAccentColor,
        ),
        const CustomText(
          text: 'Please check your email and click the link provided '
              'in the email to complete your account registration ',
          size: 14,
          fontWeight: FontWeight.w400,
        ),
        const SizedBox(
          height: 15,
        ),
        const CustomText(
          text: 'If you do not receive the email within '
              'the next 5 minutes,use the button below to resent verification email',
          size: 14,
          fontWeight: FontWeight.w400,
        ),
        const SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () {},
          child: Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppColors.greenAccentColor,
              ),
              child: const Center(
                child: CustomText(text: 'Resent Verification Email', size: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

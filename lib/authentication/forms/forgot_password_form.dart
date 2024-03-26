import 'package:firebase_integration/authentication/cubit/auth_cubit.dart';
import 'package:firebase_integration/authentication/widget/custom_circularprogress.dart';
import 'package:firebase_integration/authentication/widget/custom_text.dart';
import 'package:firebase_integration/common/constant/app_colors.dart';
import 'package:firebase_integration/widget/custom_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    return Form(
      key: authCubit.forgotFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.center,
            child: CustomText(
              text: 'Forgot Your Password?',
              size: 18,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          const CustomText(
            text:
                'Enter your email and we will send you a instruction to reset your password',
            size: 14,
            fontWeight: FontWeight.w400,
          ),
          const SizedBox(
            height: 20,
          ),
          const CustomText(text: 'Email'),
          const SizedBox(
            height: 5,
          ),
          CustomTextFormField(
            controller: authCubit.emailCon,
            hintText: 'Enter email',
            validator: (email) {
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
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              if (authCubit.forgotFormKey.currentState!.validate()) {
                authCubit.sendPasswordResetEmail();
              }
            },
            child: Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: AppColors.greenAccentColor,
                ),
                child: Center(
                  child: BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return state is ForgotPasswordLoading
                          ? customCircularProgressIndicator()
                          : const CustomText(text: 'Submit', size: 16);
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomText(
                  text: "Go to Previous Page?", fontWeight: FontWeight.w500),
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
      ),
    );
  }
}

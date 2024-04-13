import 'package:firebase_integration/authentication/cubit/auth_cubit.dart';
import 'package:firebase_integration/authentication/widget/custom_circularprogress.dart';
import 'package:firebase_integration/authentication/widget/custom_text.dart';
import 'package:firebase_integration/common/constant/app_colors.dart';
import 'package:firebase_integration/common/constant/app_icon.dart';
import 'package:firebase_integration/widget/custom_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    return Form(
      key: authCubit.signUpFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
              alignment: Alignment.center,
              child: CustomText(text: 'SignUp', size: 16)),
          const SizedBox(
            height: 30,
          ),
          const CustomText(text: 'Name'),
          const SizedBox(
            height: 5,
          ),
          CustomTextFormField(
            controller: authCubit.signUpNameCon,
            hintText: 'Enter Name',
            validator: (password) {
              if (password == null || password == '') {
                return 'please enter name';
              }
              return null;
            },
          ),
          const CustomText(text: 'Email'),
          const SizedBox(
            height: 5,
          ),
          CustomTextFormField(
            controller: authCubit.signUpEmailCon,
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
          const CustomText(text: 'Password'),
          const SizedBox(
            height: 5,
          ),
          CustomTextFormField(
            controller: authCubit.signUpPasswordCon,
            hintText: 'Enter password',
            obscure: hidePassword,
            suffixIcon: IconButton(
              icon: Icon(hidePassword
                  ? AppIcons.visibilityIcon
                  : AppIcons.visibilityOffIcon),
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
            },
          ),
          const CustomText(text: 'Confirm Password'),
          const SizedBox(
            height: 5,
          ),
          CustomTextFormField(
            controller: authCubit.signUpConfirmPasswordCon,
            hintText: 'Enter confirm password',
            obscure: hidePassword,
            suffixIcon: IconButton(
              icon: Icon(hidePassword
                  ? AppIcons.visibilityIcon
                  : AppIcons.visibilityOffIcon),
              onPressed: () {
                setState(() {
                  hidePassword = !hidePassword;
                });
              },
            ),
            validator: (confirmPassword) {
              if (confirmPassword == null || confirmPassword == '') {
                return 'please enter confirmPassword';
              } else if (confirmPassword != authCubit.signUpPasswordCon.text) {
                return 'enter correct password';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              if (authCubit.signUpFormKey.currentState!.validate()) {
                authCubit.createUserWithEmailAndPassword();
              }
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppColors.greenAccentColor,
              ),
              child: Center(
                child: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return state is SignupLoading
                        ? customCircularProgressIndicator()
                        : const CustomText(text: 'SignUp', size: 16);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomText(
                  text: "Already have an account?",
                  fontWeight: FontWeight.w500),
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

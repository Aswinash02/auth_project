import 'package:firebase_integration/authentication/cubit/auth_cubit.dart';
import 'package:firebase_integration/authentication/widget/custom_circularprogress.dart';
import 'package:firebase_integration/authentication/widget/custom_text.dart';
import 'package:firebase_integration/common/constant/app_colors.dart';
import 'package:firebase_integration/common/constant/app_icon.dart';
import 'package:firebase_integration/widget/custom_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    return Form(
      key: authCubit.loginFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
              alignment: Alignment.center,
              child: CustomText(text: 'Login', size: 16)),
          const SizedBox(
            height: 30,
          ),
          const CustomText(text: 'Phone No'),
          const SizedBox(
            height: 5,
          ),
          CustomTextFormField(
            controller: authCubit.phoneCon,
            hintText: 'Enter Phone No',
            maxLength: 10,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
            ],
            validator: (phone) {
              if (phone == null || phone == '') {
                return 'please enter email';
              } else if (phone.length < 10) {
                return 'please enter valid phone';
              }
              return null;
            },
          ),
          const CustomText(text: 'Email'),
          const SizedBox(
            height: 5,
          ),
          CustomTextFormField(
            controller: authCubit.loginEmailController,
            hintText: 'Enter Email',
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
            height: 5,
          ),
          const CustomText(text: 'Password'),
          const SizedBox(
            height: 5,
          ),
          CustomTextFormField(
              controller: authCubit.loginPasswordController,
              hintText: 'Enter Password',
              obscure: authCubit.hidePassword,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    authCubit.hidePassword = !authCubit.hidePassword;
                  });
                },
                icon: Icon(authCubit.hidePassword
                    ? AppIcons.visibilityIcon
                    : AppIcons.visibilityOffIcon),
              ),
              validator: (password) {
                if (password == null || password == '') {
                  return 'please enter password';
                } else if (password.length < 8) {
                  return 'password length is low';
                }
                return null;
              }),
          const SizedBox(
            height: 5,
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () {
                  authCubit.selectAuthScreen(AuthScreen.forgotPassword);
                },
                child: const CustomText(text: 'Forgot Password?'),
              )),
          const SizedBox(
            height: 70,
          ),
          GestureDetector(
            onTap: () {
              // authCubit.selectAuthScreen(AuthScreen.OtpVerificationForm);
              if (authCubit.loginFormKey.currentState!.validate()) {
                authCubit.selectAuthScreen(AuthScreen.otpVerificationForm);
                authCubit.loginWithUserCredential();
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
                      return state is LoginLoading
                          ? customCircularProgressIndicator()
                          : const CustomText(text: 'Login', size: 16);
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomText(
                  text: "Don't have an account?", fontWeight: FontWeight.w500),
              const SizedBox(
                width: 4,
              ),
              GestureDetector(
                  onTap: () {
                    authCubit.selectAuthScreen(AuthScreen.signUp);
                  },
                  child: const CustomText(
                      text: "SignUp",
                      size: 16,
                      color: AppColors.greenAccentColor)),
            ],
          ),
        ],
      ),
    );
  }
}

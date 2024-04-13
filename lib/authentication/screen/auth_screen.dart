import 'package:firebase_integration/authentication/cubit/auth_cubit.dart';
import 'package:firebase_integration/authentication/forms/email_verification_form.dart';
import 'package:firebase_integration/authentication/forms/login_form.dart';
import 'package:firebase_integration/authentication/forms/otp_verification_form.dart';
import 'package:firebase_integration/authentication/forms/reset_password_form.dart';
import 'package:firebase_integration/common/constant/app_colors.dart';
import 'package:firebase_integration/authentication/forms/forgot_password_form.dart';
import 'package:firebase_integration/authentication/forms/signup_form.dart';
import 'package:firebase_integration/dashboard/dashboard_form.dart';
import 'package:firebase_integration/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  static const routeName = '/LoginPage';

  static Route<void> route(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => BlocProvider(
          create: (context) => AuthCubit(), child: const AuthPage()),
    );
  }

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final authCubit = context.read<AuthCubit>();
    print('screenWidth $screenWidth');
    print('screenHeight $screenHeight');
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is EmailVerifySuccess || state is PhoneOTPVerifySuccess) {
            authCubit.setLocalUserCredential();
            Navigator.pushReplacementNamed(context, DashboardForm.routeName);
          }
          // if (state.loginEmail == 'aswin02122001@gmail.com' &&
          //     state is LoginSuccess) {
          //   Navigator.pushReplacementNamed(context, DashboardForm.routeName);
          // }
          if (state is LoginFailure ||
              state is SignupFailure ||
              state is PhoneNumVerifyFailed ||
              state is PhoneOTPVerifyFailed ||
              state is EmailVerifyFailure) {
            showErrorSnackBar(context: context, message: state.message!);
          }
        },
        builder: (_, state) {
          return screenWidth < 1000
              ? Center(
                child: Padding(
                  padding:  const EdgeInsets.all(30.0),
                  child: SizedBox(
                    width: 450,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 130,
                            child: Image(
                              image: AssetImage('asset/image/logo.png'),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const SizedBox(
                              height: 40,
                              // screenWidth / 11.8,
                              child: Image(
                                  image: AssetImage('asset/image/lizi.png'))),
                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              return _buildAuthForm(state.selectedAuthScreen);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth / 11.8),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Container(
                            color: AppColors.greenAccentColor,
                            height: double.maxFinite,
                            width: 410,
                            // width: screenWidth / 3.8,
                          )
                        ],
                      ),
                      Positioned(
                        top: 70,
                        left: 110,
                        // top: screenHeight/10.4,
                        // top: screenWidth / 21.9,
                        // left: screenWidth / 13.96,
                        child: Container(
                          height: 600,
                          width: 1100,
                          // height: screenWidth / 2.6,
                          // width: screenWidth / 1.5,
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                offset: const Offset(0, 3),
                                blurRadius: 6,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: double.maxFinite,
                                width:300,
                                // width: screenWidth / 5.21,
                                color: AppColors.greenAccentColor,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Image(
                                        image:
                                            AssetImage('asset/image/logo.png')),
                                    SizedBox(
                                      height: screenWidth / 76.8,
                                    ),
                                    SizedBox(
                                        height: screenWidth / 11.8,
                                        child: const Image(
                                            image: AssetImage(
                                                'asset/image/lizi.png')))
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: screenWidth / 10.6,
                              ),
                              SingleChildScrollView(
                                child: BlocBuilder<AuthCubit, AuthState>(
                                  builder: (context, state) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 10.0),
                                      child: SizedBox(
                                          width: screenWidth / 3.4,
                                          child: _buildAuthForm(
                                              state.selectedAuthScreen)),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }

  Widget _buildAuthForm(AuthScreen screen) {
    switch (screen) {
      case AuthScreen.login:
        return const LoginForm();
      case AuthScreen.signUp:
        return const SignUpForm();
      case AuthScreen.forgotPassword:
        return const ForgotPasswordForm();
      case AuthScreen.otpVerificationForm:
        return const OtpVerificationForm();
      case AuthScreen.resetPassword:
        return const ResetPasswordForm();
      case AuthScreen.emailVerificationForm:
        return const EmailVerificationForm();
    }
  }
}

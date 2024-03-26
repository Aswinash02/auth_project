import 'package:firebase_integration/authentication/cubit/auth_cubit.dart';
import 'package:firebase_integration/authentication/forms/email_verification_form.dart';
import 'package:firebase_integration/authentication/forms/login_form.dart';
import 'package:firebase_integration/authentication/forms/otp_verification_form.dart';
import 'package:firebase_integration/authentication/forms/reset_password_form.dart';
import 'package:firebase_integration/common/constant/app_colors.dart';
import 'package:firebase_integration/dashboard/dashboard_form.dart';
import 'package:firebase_integration/authentication/forms/forgot_password_form.dart';
import 'package:firebase_integration/authentication/forms/signup_form.dart';
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
    print('screenWidth $screenWidth');
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.pushReplacementNamed(context, DashboardForm.routeName);
          }
          if (state is LoginFailure || state is SignupFailure) {
            showErrorSnackBar(context: context, message: state.message!);
          }
        },
        builder: (_, state) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth / 11.8),
            child: Stack(
              children: [
                Row(
                  children: [
                    Container(
                      color: AppColors.greenAccentColor,
                      height: double.maxFinite,
                      width: screenWidth / 3.8,
                    )
                  ],
                ),
                Positioned(
                  top: 70,
                  left: 110,
                  // top: screenWidth/21.9,
                  // left: screenWidth/13.96,
                  child: Container(
                    height: screenWidth / 2.6,
                    width: screenWidth / 1.5,
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
                          width: screenWidth / 5.21,
                          color: AppColors.greenAccentColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Image(
                                  image: AssetImage('asset/image/logo.png')),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                  height: 130,
                                  child: Image(
                                      image:
                                          AssetImage('asset/image/lizi.png')))
                            ],
                          ),
                        ),
                        SizedBox(
                          width: screenWidth / 10.6,
                        ),
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            return SizedBox(
                                width: screenWidth / 3.4,
                                child:
                                    _buildAuthScreen(state.selectedAuthScreen));
                          },
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

  Widget _buildAuthScreen(AuthScreen screen) {
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

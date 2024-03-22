import 'package:firebase_integration/authentication/cubit/auth_cubit.dart';
import 'package:firebase_integration/authentication/forms/login_form.dart';
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
            padding: const EdgeInsets.symmetric(horizontal: 130.0),
            child: Stack(
              children: [
                Row(
                  children: [
                    Container(
                      color: AppColors.greenAccentColor,
                      height: double.maxFinite,
                      width: 400,
                    )
                  ],
                ),
                Positioned(
                  top: 70,
                  left: 110,
                  child: Container(
                    height: 600,
                    width: 1000,
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
                          width: 290,
                          color: AppColors.greenAccentColor,
                          child: const Image(
                            image: AssetImage('asset/image/logo.png'),
                          ),
                        ),
                        const SizedBox(
                          width: 145,
                        ),
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            return SizedBox(
                                width: 450,
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
      case AuthScreen.resetPassword:
        return const ResetPasswordForm();
    }
  }
}





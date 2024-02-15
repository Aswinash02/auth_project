import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_integration/home/cubit/home_cubit.dart';
import 'package:firebase_integration/home/screen/home_screen.dart';
import 'package:firebase_integration/login/cubit/login_cubit.dart';
import 'package:firebase_integration/login/email_verification/screen/email_verification_screen.dart';
import 'package:firebase_integration/login/forgot_password/screen/forgot_password_screen.dart';
import 'package:firebase_integration/login/forgot_password/screen/reset_password_screen.dart';
import 'package:firebase_integration/login/screen/login_screen.dart';
import 'package:firebase_integration/signup/screen/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    print('__________________');
    print(user);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: user != null
          ? BlocProvider(
              create: (context) => HomeCubit(), child: const HomePage())
          : BlocProvider(
              create: (context) => LoginCubit(), child: const LoginPage()),
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginPage.routeName:
        return LoginPage.route(settings);
      case SignUpPage.routeName:
        return SignUpPage.route(settings);
      case HomePage.routeName:
        return HomePage.route(settings);
      case EmailVerificationScreen.routeName:
        return EmailVerificationScreen.route(settings);
      case ForgotPasswordScreen.routeName:
        return ForgotPasswordScreen.route(settings);
      case ResetPasswordScreen.routeName:
        return ResetPasswordScreen.route(settings);
      default:
        return MaterialPageRoute(
            builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ));
    }
  }
}

import 'package:firebase_integration/common/constant/app_colors.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  static const routeName = '/SettingScreen';

  static Route route(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => SettingScreen());
  }

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Setting screen'),
      ),
    );
  }
}

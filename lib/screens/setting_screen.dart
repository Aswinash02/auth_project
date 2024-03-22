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
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('Setting screen'),
      ),
    );
  }
}

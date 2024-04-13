import 'package:firebase_integration/common/constant/app_colors.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  static const routeName = '/OrderScreen';

  static Route route(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const OrderScreen());
  }

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Order screen'),
      ),
    );
  }
}

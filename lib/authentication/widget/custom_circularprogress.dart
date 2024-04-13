import 'package:flutter/material.dart';

Widget customCircularProgressIndicator() {
  return const SizedBox(
    width: 24,
    height: 24,
    child: CircularProgressIndicator(
      backgroundColor: Colors.green,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      strokeWidth: 2,
    ),
  );
}

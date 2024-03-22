import 'package:firebase_integration/common/constant/app_colors.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText(
      {super.key, required this.text, this.size, this.fontWeight, this.color});

  final String text;
  final double? size;
  final FontWeight? fontWeight;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color ?? AppColors.blackColor,
          fontWeight: fontWeight ?? FontWeight.w600,
          fontSize: size ?? 14),
    );
  }
}

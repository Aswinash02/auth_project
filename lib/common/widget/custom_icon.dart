import 'package:firebase_integration/common/constant/app_colors.dart';
import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon(
      {super.key, required this.icon, this.size, this.height, this.width, this.color});

  final IconData icon;
  final double? size;
  final double? height;
  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 28,
      width: width ?? 28,
      decoration:  BoxDecoration(
        color: color ?? AppColors.greenAccentColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: AppColors.whiteColor,
        size: size ?? 16,
      ),
    );
  }
}

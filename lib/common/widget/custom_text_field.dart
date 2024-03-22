import 'package:firebase_integration/common/constant/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.onChanged,
      required this.hintText,
      this.maxLine,
      this.readOnly});

  final TextEditingController controller;
  final void Function(String) onChanged;
  final String hintText;
  final int? maxLine;
  final bool? readOnly;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: maxLine ?? 1,
      readOnly: readOnly ?? false,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.green.withOpacity(0.1),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: AppColors.greenAccentColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: AppColors.greenAccentColor)),
          hintText: hintText),
    );
  }
}

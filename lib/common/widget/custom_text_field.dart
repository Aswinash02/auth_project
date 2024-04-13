import 'package:firebase_integration/common/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.onChanged,
      required this.hintText,
      this.maxLine,
      this.readOnly,
      this.inputFormatters});

  final TextEditingController controller;
  final void Function(String) onChanged;
  final String hintText;
  final int? maxLine;
  final bool? readOnly;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: maxLine ?? 1,
      readOnly: readOnly ?? false,
      inputFormatters: inputFormatters,
      cursorColor: AppColors.greenAccentColor,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.green.withOpacity(0.1),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.greenAccentColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.greenAccentColor)),
          hintText: hintText),
    );
  }
}

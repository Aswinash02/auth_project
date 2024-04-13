import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.obscure,
    this.prefixIcon,
    this.suffixIcon,
    required this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final bool? obscure;
  final Icon? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    final screenWidth=MediaQuery.of(context).size.width;
    return SizedBox(
      height: 68,
      child: TextFormField(
        controller: controller,
        obscureText: obscure ?? false,
        cursorColor: Colors.grey,
        keyboardType: keyboardType ?? TextInputType.text,
        inputFormatters: inputFormatters ?? [],
        maxLength: maxLength,
        decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffixIcon,
            suffixIconColor: Colors.grey,
            prefixIcon: prefixIcon,
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                borderRadius: BorderRadius.circular(4)),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                borderRadius: BorderRadius.circular(4)),
            disabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                borderRadius: BorderRadius.circular(4)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                borderRadius: BorderRadius.circular(4))),
        validator: validator,
      ),
    );
  }
}

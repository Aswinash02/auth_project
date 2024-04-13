import 'package:firebase_integration/authentication/cubit/auth_cubit.dart';
import 'package:firebase_integration/authentication/widget/custom_circularprogress.dart';
import 'package:firebase_integration/authentication/widget/custom_text.dart';
import 'package:firebase_integration/common/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpVerificationForm extends StatefulWidget {
  const OtpVerificationForm({super.key});

  @override
  State<OtpVerificationForm> createState() => _OtpVerificationFormState();
}

class _OtpVerificationFormState extends State<OtpVerificationForm> {
  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomText(
          text: 'Otp Verification',
        ),
        const SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            otpContainer(
              controller: authCubit.otp1,
            ),
            otpContainer(
              controller: authCubit.otp2,
            ),
            otpContainer(
              controller: authCubit.otp3,
            ),
            otpContainer(
              controller: authCubit.otp4,
            ),
            otpContainer(
              controller: authCubit.otp5,
            ),
            otpContainer(
              controller: authCubit.otp6,
            ),
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        GestureDetector(
          onTap: () {
            authCubit.verifyOTP();
          },
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: AppColors.greenAccentColor,
                ),
                child: Center(
                  child: state is PhoneOTPVerifyLoading
                      ? customCircularProgressIndicator()
                      : CustomText(text: 'Submit', size: 16),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomText(
                text: "If You Not Got OTP?", fontWeight: FontWeight.w500),
            const SizedBox(
              width: 4,
            ),
            GestureDetector(
                onTap: () {},
                child: const CustomText(
                    text: "Resent",
                    size: 16,
                    color: AppColors.greenAccentColor)),
          ],
        ),
      ],
    );
  }

  Widget otpContainer({required TextEditingController controller}) {
    FocusNode focusNode = FocusNode();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.green.shade100,
        ),
        height: 50,
        width: 50,
        child: TextField(
          controller: controller,
          cursorColor: AppColors.greenAccentColor,
          maxLength: 1,
          keyboardType: TextInputType.number,
          focusNode: focusNode,
          onChanged: (value) {
            if (value.isNotEmpty) {
              focusNode.requestFocus();
            } else {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 20),
              alignLabelWithHint: true,
              counterText: '',
              counterStyle: TextStyle(fontSize: 0),
              border: InputBorder.none),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
        ),
      ),
    );
  }
}

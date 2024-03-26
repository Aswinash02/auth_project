import 'package:firebase_integration/common/constant/app_colors.dart';
import 'package:flutter/material.dart';

// class BottomButton extends StatelessWidget {
//   const BottomButton(
//       {super.key,
//       required this.buttonText,
//       required this.onTap,
//       required this.disable,
//       required this.cxt});
//
//   final String buttonText;
//   final void Function() onTap;
//   final bool disable;
//   final BuildContext cxt;
//
//   @override
//   Widget build(cxt) {
//     return GestureDetector(
//       onTap: disable ? null : onTap,
//       child: Container(
//         decoration: BoxDecoration(
//             color: disable ? Colors.grey : Colors.green,
//             borderRadius: BorderRadius.circular(10)),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
//           child: Text(buttonText),
//         ),
//       ),
//     );
//     ;
//   }
// }

Widget bottomButton(
    {required String buttonText,
    required void Function() onTap,
    required bool disable}) {
  return GestureDetector(
    onTap: disable ? null : onTap,
    child: Container(
      decoration: BoxDecoration(
          color: disable ? AppColors.greyShade : AppColors.greenAccentColor,
          borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Text(buttonText),
      ),
    ),
  );
}

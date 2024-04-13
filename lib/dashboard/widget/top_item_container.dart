import 'package:flutter/material.dart';

class TopItemContainer extends StatelessWidget {
  const TopItemContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:180 ,
      child: ListView.builder(
        scrollDirection:  Axis.horizontal,
        itemCount: 10,
          itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15)),
            height: 170,
            width: 180,
          ),
        );
      }),
    );
  }
}

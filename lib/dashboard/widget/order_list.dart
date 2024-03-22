import 'package:firebase_integration/common/constant/app_colors.dart';
import 'package:firebase_integration/common/constant/app_icon.dart';
import 'package:firebase_integration/common/widget/custom_icon.dart';
import 'package:flutter/material.dart';

class OrderList extends StatelessWidget {
  const OrderList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(10)),
        height: 420,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(
                      height: 70,
                      child: Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Red Saffron',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              const Text(
                                'Weight 2 kg',
                                style: TextStyle(
                                  color: AppColors.greyColor,
                                ),
                              ),
                              SizedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CustomIcon(
                                      icon: AppIcons.removeIcon,
                                      height: 18,
                                      color: AppColors.greenAccentShade,
                                    ),
                                    const Text(
                                      '1',
                                      style: TextStyle(
                                          color: AppColors.greenAccentColor,
                                          fontSize: 16),
                                    ),
                                    CustomIcon(
                                      icon: AppIcons.addIcon,
                                      height: 18,
                                      color: AppColors.greenAccentShade,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const Spacer(),
                          const Text('\$300',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.greenAccentColor)),
                        ],
                      ),
                    ),
                    Divider(
                      color: AppColors.greyShade,
                    )
                  ],
                );
              }),
        ));
  }
}

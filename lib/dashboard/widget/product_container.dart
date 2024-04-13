import 'package:firebase_integration/cart/screen/cart_screen.dart';
import 'package:firebase_integration/common/constant/app_colors.dart';
import 'package:firebase_integration/common/constant/app_icon.dart';
import 'package:firebase_integration/common/widget/create_product_model.dart';
import 'package:firebase_integration/common/widget/custom_icon.dart';
import 'package:firebase_integration/common/widget/logout_dialog.dart';
import 'package:firebase_integration/dashboard/cubit/dashboard_cubit.dart';
import 'package:firebase_integration/product/cubit/product_cubit.dart';
import 'package:firebase_integration/product/model/product_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductContainer extends StatelessWidget {
  const ProductContainer({super.key, required this.data});

  final ProductModel data;

  @override
  Widget build(BuildContext context) {
    final dashboardCubit = context.read<DashboardCubit>();
    final productCubit = context.read<ProductCubit>();
    return GestureDetector(
      onTap: () {
        productDetailModel(context: context);
        productCubit.fetchCartProduct(data :data);
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.whiteColor, borderRadius: BorderRadius.circular(15)),
          height: 210,
          width: 180,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 115,
                      width: double.infinity,
                      child: Image.network(data.imageUrl),
                    ),
                    Positioned(
                        right: 0,
                        child: dashboardCubit.state.userType == UserType.user
                            ? BlocBuilder<ProductCubit, ProductState>(
                                builder: (context, state) {
                                  return IconContainer(
                                      icon: data.wishlist
                                          ? AppIcons.favoriteIcon
                                          : AppIcons.favoriteOutlineIcon,
                                      color: AppColors.redColor,
                                      onTap: () async {
                                        await productCubit
                                            .addWishlistProduct(data);
                                      });
                                },
                              )
                            : dashboardCubit.state.selectedTitle ==
                                    ScreenName.dashboard
                                ? Container()
                                : Column(
                                    children: [
                                      IconContainer(
                                          icon: Icons.edit_square,
                                          color: AppColors.greenAccentColor,
                                          onTap: () {
                                            productCubit
                                                .emitSelectedProduct(data);
                                            productModel(context);
                                          }),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      IconContainer(
                                          icon: AppIcons.deleteIcon,
                                          color: AppColors.redColor,
                                          onTap: () {
                                            deleteProductAlertDialog(
                                                context: context, id: data.id);
                                          }),
                                    ],
                                  ))
                  ],
                ),
                Text(data.productName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(
                  data.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color:AppColors.greyColor),
                ),
                Row(
                  children: [
                    Text('\$ ${data.price}',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.greenAccentColor)),
                    Text(
                      data.unit != "" ? '/ ${data.unit}' : '',
                      style: const TextStyle(color: AppColors.greyColor),
                    ),
                    const Spacer(),
                    dashboardCubit.state.userType == UserType.user
                        ? GestureDetector(
                            onTap: () {
                              // productCubit.emitSelectedProduct(data);
                              // productDetailModel(context: context, data: data);
                              // Navigator.pushNamed(context, CartScreen.routeName);
                            },
                            child: const CustomIcon(
                              icon: AppIcons.shoppingCartIcon,
                              size: 18,
                            ),
                          )
                        : Container(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IconContainer extends StatelessWidget {
  const IconContainer(
      {super.key,
      required this.color,
      required this.icon,
      required this.onTap});

  final Color color;
  final IconData icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 28,
        width: 28,
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3)),
          color: color.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
    );
  }
}

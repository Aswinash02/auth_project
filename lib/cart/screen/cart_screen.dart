import 'package:firebase_integration/authentication/widget/custom_text.dart';
import 'package:firebase_integration/common/constant/app_colors.dart';
import 'package:firebase_integration/common/constant/app_icon.dart';
import 'package:firebase_integration/common/widget/custom_icon.dart';
import 'package:firebase_integration/product/cubit/product_cubit.dart';
import 'package:firebase_integration/product/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  static const routeName = '/cartScreen';

  static Route route(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const CartScreen());
  }

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final productCubit = context.read<ProductCubit>();
    return AlertDialog(
      content: Container(
        color: Colors.red,
      ),
    );

    // Opacity(opacity: 1,child:Padding(
    //     padding: const EdgeInsets.all(15.0),
    //     child: Center(
    //       child: SizedBox(
    //         width: 1200,
    //         height: double.infinity,
    //         child: Row(
    //           children: [
    //             Container(
    //               width: 650,
    //               height: double.infinity,
    //               decoration: BoxDecoration(
    //                   image: DecorationImage(
    //                       image: NetworkImage(
    //                           productCubit.state.selectedProduct.imageUrl),
    //                       fit: BoxFit.cover)),
    //             )
    //           ],
    //         ),
    //       ),
    //     )) );
  }
}

Future<void> productDetailModel({required BuildContext context}) {
  return showDialog(
    barrierColor: Colors.green.withOpacity(0.1),
    context: context,
    builder: (BuildContext context) {
      final productCubit = context.watch<ProductCubit>();
      final state = context.watch<ProductCubit>().state;
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                height: 400,
                width: 400,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.greenAccentColor),
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        image: NetworkImage(state.selectedProduct.imageUrl),
                        fit: BoxFit.cover)),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: state.selectedProduct.productName,
                      size: 30,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 400,
                      child: CustomText(
                        text: state.selectedProduct.description,
                        textAlign: TextAlign.start,
                        maxLines: 7,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomText(
                      text: '\$ ${state.selectedProduct.price}',
                      color: AppColors.greenAccentColor,
                      size: 25,
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: state.cartProductCount != 0
                              ? () => productCubit.removeToCart(data: state.selectedProduct)
                              : null,
                          child: CustomIcon(
                            icon: AppIcons.removeIcon,
                            color: state.cartProductCount == 0
                                ? AppColors.greyShade
                                : AppColors.greenAccentColor,
                          ),
                        ),

                        SizedBox(
                          width: 30,
                          child: CustomText(
                            text: state.cartProductCount.toString(),
                            size: 20,
                          ),
                        ),
                        // BlocBuilder<ProductCubit, ProductState>(
                        //   builder: (context, state) {
                        //     return CustomText(
                        //       text: state.cartProductCount.toString(),
                        //       size: 20,
                        //     );
                        //   },
                        // ),

                        GestureDetector(
                            onTap: () {
                              productCubit.addToCart(
                                  data: state.selectedProduct);
                            },
                            child: const CustomIcon(icon: AppIcons.addIcon)),
                        const SizedBox(
                          width: 40,
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: state.cartProductCount == 0
                                  ? AppColors.greyShade
                                  : AppColors.greenAccentColor,
                              border: Border.all(
                                color: AppColors.greenAccentColor,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: const CustomText(
                            text: 'Add to Cart',
                            size: 20,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

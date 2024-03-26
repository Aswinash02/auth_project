import 'package:firebase_integration/common/constant/app_colors.dart';
import 'package:firebase_integration/dashboard/widget/product_container.dart';
import 'package:firebase_integration/product/cubit/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  static const routeName = '/WishlistScreen';

  static Route route(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const WishlistScreen());
  }

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    final productCubit = context.read<ProductCubit>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: AppColors.greenAccentColor,
        centerTitle: true,
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          return state is ProductLoadingState
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : state.productWishlist.isEmpty
                  ? const Center(
                      child: Text('No Wishlist'),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisExtent: 250,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              crossAxisCount: 4),
                      itemCount: productCubit.state.productWishlist.length,
                      itemBuilder: (context, index) {
                        final data = productCubit.state.productWishlist[index];

                        return ProductContainer(
                          data: data,
                        );
                      });
        },
      ),
    );
  }
}

import 'package:firebase_integration/category/cubit/category_cubit.dart';
import 'package:firebase_integration/category/screen/category_screen.dart';
import 'package:firebase_integration/common/constant/app_colors.dart';
import 'package:firebase_integration/common/constant/app_icon.dart';
import 'package:firebase_integration/common/widget/bottom_button.dart';
import 'package:firebase_integration/common/widget/create_product_model.dart';
import 'package:firebase_integration/common/widget/custom_icon.dart';
import 'package:firebase_integration/common/widget/custom_text_field.dart';
import 'package:firebase_integration/dashboard/cubit/dashboard_cubit.dart';
import 'package:firebase_integration/dashboard/widget/product_container.dart';
import 'package:firebase_integration/product/cubit/product_cubit.dart';
import 'package:firebase_integration/product/model/product_model.dart';
import 'package:firebase_integration/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  static const routeName = '/ProductScreen';

  static Route route(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => ProductScreen());
  }

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    final productCubit = context.read<ProductCubit>();
    final categoryCubit = context.read<CategoryCubit>();
    super.initState();
    productCubit.fetchCategoryName(categoryCubit.state.categoryList);
  }

  @override
  Widget build(BuildContext context) {
    final productCubit = context.read<ProductCubit>();
    final categoryCubit = context.read<CategoryCubit>();
    final dashboardCubit = context.read<DashboardCubit>().state;

    return BlocConsumer<ProductCubit, ProductState>(
      listener: (context, state) {
        if (state is ProductErrorState) {
          showErrorSnackBar(context: context, message: state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: AppColors.greenAccentColor,
            centerTitle: true,
            actions: [
              dashboardCubit.userType == UserType.admin
                  ? GestureDetector(
                      onTap: () {
                        productModel(context);
                      },
                      child: CustomIcon(
                          color: AppColors.greyShade, icon: AppIcons.addIcon))
                  : Container(),
              const SizedBox(
                width: 10,
              )
            ],
          ),
          body: state is ProductLoadingState
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: BlocBuilder<ProductCubit, ProductState>(
                    builder: (context, state) {
                      return StreamBuilder<List<ProductModel>>(
                        stream: productCubit.fetchProduct(),
                        builder: (context,
                            AsyncSnapshot<List<ProductModel>> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.greenAccentColor,
                              ),
                            );
                          } else if (productCubit
                                  .state.filteredProducts.isEmpty &&
                              categoryCubit.state.selectedCategoryName != '') {
                            return const Center(child: Text('No data Found'));
                          } else {
                            return GridView.builder(
                              itemCount:
                                  categoryCubit.state.selectedCategoryName == ''
                                      ? snapshot.data!.length
                                      : productCubit
                                          .state.filteredProducts.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisExtent: 250,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                crossAxisCount: 4,
                              ),
                              itemBuilder: (context, index) {
                                final data =
                                    categoryCubit.state.selectedCategoryName ==
                                            ''
                                        ? snapshot.data![index]
                                        : productCubit
                                            .state.filteredProducts[index];

                                return SizedBox(
                                    height: 220,
                                    child: ProductContainer(data: data));
                              },
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
        );
      },
    );
  }
}

import 'package:firebase_integration/category/cubit/category_cubit.dart';
import 'package:firebase_integration/category/model.dart';
import 'package:firebase_integration/common/constant/app_colors.dart';
import 'package:firebase_integration/common/constant/app_icon.dart';
import 'package:firebase_integration/common/widget/custom_icon.dart';
import 'package:firebase_integration/dashboard/cubit/dashboard_cubit.dart';
import 'package:firebase_integration/dashboard/widget/category_container.dart';
import 'package:firebase_integration/dashboard/widget/discountshop_container_list.dart';
import 'package:firebase_integration/dashboard/widget/order_list.dart';
import 'package:firebase_integration/dashboard/widget/product_container.dart';
import 'package:firebase_integration/dashboard/widget/top_item_container.dart';
import 'package:firebase_integration/product/cubit/product_cubit.dart';
import 'package:firebase_integration/product/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const routeName = '/DashboardScreen';

  static Route route(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const DashboardScreen());
  }

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final dashboardCubit = context.read<DashboardCubit>();
    final productCubit = context.read<ProductCubit>();
    final categoryCubit = context.read<CategoryCubit>();
    print('==================================');
    print(categoryCubit.state.errorMessage);
    print('==================================');

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    dashboardCubit.selectedScreen(ScreenName.category);
                  },
                  child: const Text(
                    'View more',
                    style: TextStyle(color: AppColors.greenAccentColor),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
             SizedBox(
              height: 100,
              child: StreamBuilder<List<CategoryModel>>(
                  stream: categoryCubit.fetchCategory(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: Text('No Data Found'));
                    }
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                        snapshot.data!.length > 20 ? 20 : snapshot.data?.length,
                        itemBuilder: (context, index) {
                          final data = categoryCubit.state.categoryList[index];
                          return CategoryContainer(data: data);
                        });
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Popular Products',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    dashboardCubit.selectedScreen(ScreenName.product);
                  },
                  child: const Text(
                    'View more',
                    style: TextStyle(color: AppColors.greenAccentColor),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
             SizedBox(
              height: 220,
              child: StreamBuilder<List<ProductModel>>(
                  stream: productCubit.fetchProduct(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: Text('No Data Found'));
                    }
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                        snapshot.data!.length > 10 ? 10 : snapshot.data?.length,
                        itemBuilder: (context, index) {
                          final data = productCubit.state.productList[index];
                          return ProductContainer(
                            data: data,
                          );
                        });
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
            const Row(
              children: [
                Expanded(
                  flex: 3,
                  child: SizedBox(
                      child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Discount Shop',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                            'View more',
                            style: TextStyle(color: AppColors.greenAccentColor),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DiscountContainerList(),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            'Top Items',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          CustomIcon(icon:AppIcons.arrowBackward),
                          SizedBox(
                            width: 10,
                          ),
                          CustomIcon(icon: AppIcons.arrowForward),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TopItemContainer(),
                    ],
                  )),
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order List',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      OrderList(),
                    ],
                  ),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}

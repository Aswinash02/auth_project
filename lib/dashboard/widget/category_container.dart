import 'package:firebase_integration/category/cubit/category_cubit.dart';
import 'package:firebase_integration/category/model.dart';
import 'package:firebase_integration/category/screen/category_screen.dart';
import 'package:firebase_integration/common/widget/create_category_model.dart';
import 'package:firebase_integration/common/widget/logout_dialog.dart';
import 'package:firebase_integration/dashboard/cubit/dashboard_cubit.dart';
import 'package:firebase_integration/product/cubit/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryContainer extends StatelessWidget {
  const CategoryContainer({super.key, required this.data});

  final CategoryModel data;

  @override
  Widget build(BuildContext context) {
    final categoryCubit = context.read<CategoryCubit>();
    final productCubit = context.read<ProductCubit>();
    final dashboardCubit = context.read<DashboardCubit>();
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          categoryCubit.emitCategoryName(data.name);
          productCubit.filterProducts(data.name);
          dashboardCubit.selectedScreen(ScreenName.product);
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              height: 90,
              width: 85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: NetworkImage(data.imageUrl),
                                fit: BoxFit.cover)),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 70,
                    child: Center(
                      child: Text(
                        data.name,
                        style: TextStyle(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                ],
              ),
            ),
            dashboardCubit.state.selectedTitle == ScreenName.dashboard ||
                    dashboardCubit.state.userType == UserType.user
                ? Container()
                : Positioned(
                    right: 0,
                    top: 0,
                    child: Column(
                      children: [
                        iconContainer(
                          icon: Icons.edit_square,
                          color: Colors.green,
                          onTap: () {
                            categoryCubit.emitCategoryDetails(data: data);
                            showCustomBottomSheet(context);
                          },
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        iconContainer(
                          icon: Icons.delete,
                          color: Colors.red,
                          onTap: () {
                            deleteCategoryAlertDialog(
                                context: context, id: data.id);
                          },
                        ),
                      ],
                    ))
          ],
        ),
      ),
    );
  }

  Widget iconContainer(
      {required IconData icon,
      required Color color,
      required void Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 18,
        width: 18,
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3)),
          color: color.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: color,
          size: 12,
        ),
      ),
    );
  }
}

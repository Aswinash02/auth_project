import 'package:firebase_integration/authentication/cubit/auth_cubit.dart';
import 'package:firebase_integration/category/cubit/category_cubit.dart';
import 'package:firebase_integration/dashboard/cubit/dashboard_cubit.dart';
import 'package:firebase_integration/product/cubit/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void logOutDialog(BuildContext context) {
  final authCubit = context.read<AuthCubit>();
  final dashboardCubit = context.read<DashboardCubit>();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              dashboardCubit.emitUserType();
              authCubit.signOutUser();
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
        ],
      );
    },
  );
}

void deleteProductAlertDialog(
    {required BuildContext context, required String id}) {
  final productCubit = context.read<ProductCubit>();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Alert'),
        content: const Text('Are you sure you want to Delete the Product?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              productCubit.deleteProduct(id);
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
        ],
      );
    },
  );
}

void deleteCategoryAlertDialog(
    {required BuildContext context, required String id}) {
  final categoryCubit = context.read<CategoryCubit>();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Alert'),
        content: const Text('Are you sure you want to Delete the Category?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              categoryCubit.deleteCategory(id);
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
        ],
      );
    },
  );
}

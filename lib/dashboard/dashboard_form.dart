import 'package:firebase_integration/authentication/cubit/auth_cubit.dart';
import 'package:firebase_integration/authentication/screen/auth_screen.dart';
import 'package:firebase_integration/category/cubit/category_cubit.dart';
import 'package:firebase_integration/common/constant/app_colors.dart';
import 'package:firebase_integration/common/constant/app_icon.dart';
import 'package:firebase_integration/common/widget/custom_icon.dart';
import 'package:firebase_integration/common/widget/logout_dialog.dart';
import 'package:firebase_integration/dashboard/cubit/dashboard_cubit.dart';
import 'package:firebase_integration/dashboard/screen/dashboardscreen.dart';
import 'package:firebase_integration/dashboard/widget/order_list.dart';
import 'package:firebase_integration/category/screen/category_screen.dart';
import 'package:firebase_integration/product/cubit/product_cubit.dart';
import 'package:firebase_integration/screens/order_screen.dart';
import 'package:firebase_integration/product/screen/product_screen.dart';
import 'package:firebase_integration/screens/setting_screen.dart';
import 'package:firebase_integration/screens/wishlist_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardForm extends StatefulWidget {
  const DashboardForm({super.key});

  static const routeName = '/DashboardForm';

  static Route route(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const DashboardForm());
  }

  @override
  State<DashboardForm> createState() => _DashboardFormState();
}

class _DashboardFormState extends State<DashboardForm> {
  @override
  void initState() {
    super.initState();
    final categoryCubit = context.read<CategoryCubit>();
    final dashboardCubit = context.read<DashboardCubit>();
    dashboardCubit.fetchUserType();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LogOut) {
          Navigator.pushReplacementNamed(context, AuthPage.routeName);
        }
      },
      builder: (context, state) {
        return kIsWeb
            ? Scaffold(
                body: Row(
                  children: [
                    screenWidth < 1000
                        ? minimizeDrawerContainer()
                        : drawerContainer(),
                    BlocBuilder<DashboardCubit, DashboardState>(
                      builder: (context, state) {
                        return Expanded(
                          child: _buildScreen(state.selectedTitle),
                        );
                      },
                    ),
                  ],
                ),
              )
            : SafeArea(
                child: Scaffold(
                  appBar: AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: AppColors.greenAccentColor,
                      leading: IconButton(
                        onPressed: () {},
                        icon: const Icon(AppIcons.menuIcon),
                      )),
                  body: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            dashboardContainer(
                                title: 'Category',
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, CategoryScreen.routeName);
                                }),
                            const Spacer(),
                            dashboardContainer(
                                title: 'Product',
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, ProductScreen.routeName);
                                }),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            dashboardContainer(
                                title: 'WishList',
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, WishlistScreen.routeName);
                                }),
                            const Spacer(),
                            dashboardContainer(
                                title: 'Orders',
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, OrderScreen.routeName);
                                }),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            dashboardContainer(
                                title: 'Settings',
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, SettingScreen.routeName);
                                }),
                            const Spacer(),
                            dashboardContainer(
                                title: 'Log Out',
                                onTap: () {
                                  logOutDialog(context);
                                }),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }

  Widget dashboardContainer(
      {required String title, required void Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        width: 180,
        decoration: BoxDecoration(
            color: AppColors.redColor, borderRadius: BorderRadius.circular(15)),
        child: Center(
            child: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        )),
      ),
    );
  }

  Widget drawerContainer() {
    final dashboardCubit = context.read<DashboardCubit>();
    final categoryCubit = context.read<CategoryCubit>();
    final productCubit = context.read<ProductCubit>();
    return Container(
      color: AppColors.greenAccentColor.withOpacity(0.1),
      width: 280,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            drawerRow(
                icon: AppIcons.dashboardIcon,
                title: ScreenName.dashboard,
                onTap: () {
                  dashboardCubit.selectedScreen(ScreenName.dashboard);
                }),
            drawerRow(
                icon: AppIcons.categoryIcon,
                title: ScreenName.category,
                onTap: () {
                  dashboardCubit.selectedScreen(ScreenName.category);
                }),
            drawerRow(
                icon: AppIcons.settingsIcon,
                title: ScreenName.product,
                onTap: () {
                  categoryCubit.emitCategoryName('');
                  productCubit.emitEmptyCategory('');
                  dashboardCubit.selectedScreen(ScreenName.product);
                }),
            dashboardCubit.state.userType == UserType.user
                ? drawerRow(
                    icon: AppIcons.favoriteIcon,
                    title: ScreenName.wishList,
                    onTap: () {
                      dashboardCubit.selectedScreen(ScreenName.wishList);
                    })
                : Container(),
            drawerRow(
                icon: AppIcons.shoppingCartIcon,
                title: ScreenName.order,
                onTap: () {
                  dashboardCubit.selectedScreen(ScreenName.order);
                }),
            drawerRow(
                icon: AppIcons.settingsIcon,
                title: ScreenName.setting,
                onTap: () {
                  dashboardCubit.selectedScreen(ScreenName.setting);
                }),
            const Spacer(),
            drawerRow(
                icon: AppIcons.logOutIcon,
                title: ScreenName.logOut,
                onTap: () {
                  logOutDialog(context);
                }),
          ],
        ),
      ),
    );
  }

  Widget minimizeDrawerContainer() {
    final dashboardCubit = context.read<DashboardCubit>();
    return Container(
      color: AppColors.greenAccentColor.withOpacity(0.1),
      width: 90,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            minimizeDrawerRow(
                icon: AppIcons.dashboardIcon,
                onTap: () {
                  dashboardCubit.selectedScreen(ScreenName.dashboard);
                }),
            minimizeDrawerRow(
                icon: AppIcons.categoryIcon,
                onTap: () {
                  dashboardCubit.selectedScreen(ScreenName.category);
                }),
            minimizeDrawerRow(
                icon: AppIcons.settingsIcon,
                onTap: () {
                  dashboardCubit.selectedScreen(ScreenName.product);
                  // productCubit.filterProducts('');
                }),
            minimizeDrawerRow(
                icon: AppIcons.favoriteIcon,
                onTap: () {
                  dashboardCubit.selectedScreen(ScreenName.wishList);
                }),
            minimizeDrawerRow(
                icon: AppIcons.shoppingCartIcon,
                onTap: () {
                  dashboardCubit.selectedScreen(ScreenName.order);
                }),
            minimizeDrawerRow(
                icon: AppIcons.settingsIcon,
                onTap: () {
                  dashboardCubit.selectedScreen(ScreenName.setting);
                }),
            const Spacer(),
            minimizeDrawerRow(
                icon: AppIcons.logOutIcon,
                onTap: () {
                  logOutDialog(context);
                }),
          ],
        ),
      ),
    );
  }

  Widget drawerRow(
      {required ScreenName title,
      required IconData icon,
      required void Function() onTap}) {
    String titleData;
    if (title == ScreenName.dashboard) {
      titleData = 'Dashboard';
    } else if (title == ScreenName.category) {
      titleData = 'Categories';
    } else if (title == ScreenName.product) {
      titleData = 'Products';
    } else if (title == ScreenName.setting) {
      titleData = 'Settings';
    } else if (title == ScreenName.logOut) {
      titleData = 'Log Out';
    } else if (title == ScreenName.wishList) {
      titleData = 'Favorite';
    } else {
      titleData = 'Orders';
    }
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: state.selectedTitle == title
                  ? AppColors.greenAccentColor
                  : AppColors.whiteColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CustomIcon(icon: icon),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    titleData,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget minimizeDrawerRow(
      {required IconData icon, required void Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
          return CustomIcon(icon: icon);
        }),
      ),
    );
  }

  Widget _buildScreen(ScreenName selectedTitle) {
    switch (selectedTitle) {
      case ScreenName.dashboard:
        return const DashboardScreen();
      case ScreenName.category:
        return const CategoryScreen();
      case ScreenName.product:
        return const ProductScreen();
      case ScreenName.wishList:
        return const WishlistScreen();
      case ScreenName.order:
        return const OrderList();
      case ScreenName.setting:
        return const SettingScreen();
      default:
        return Container();
    }
  }
}

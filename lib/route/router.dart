import 'dart:ui';
import 'package:firebase_integration/authentication/cubit/auth_cubit.dart';
import 'package:firebase_integration/cart/screen/cart_screen.dart';
import 'package:firebase_integration/category/cubit/category_cubit.dart';
import 'package:firebase_integration/category/screen/category_screen.dart';
import 'package:firebase_integration/common/global_deps.dart';
import 'package:firebase_integration/dashboard/cubit/dashboard_cubit.dart';
import 'package:firebase_integration/dashboard/dashboard_form.dart';
import 'package:firebase_integration/dashboard/screen/dashboardscreen.dart';
import 'package:firebase_integration/authentication/screen/auth_screen.dart';
import 'package:firebase_integration/product/cubit/product_cubit.dart';
import 'package:firebase_integration/screens/order_screen.dart';
import 'package:firebase_integration/product/screen/product_screen.dart';
import 'package:firebase_integration/screens/setting_screen.dart';
import 'package:firebase_integration/screens/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class LiziMaterialApp extends StatefulWidget {
  const LiziMaterialApp({super.key});

  static final _navigatorKey = GlobalKey<NavigatorState>();

  static NavigatorState get navigator => _navigatorKey.currentState!;

  @override
  State<LiziMaterialApp> createState() => _LiziMaterialAppState();
}

class _LiziMaterialAppState extends State<LiziMaterialApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authCubit = getIt.get<AuthCubit>();
      authCubit.isLoggedIn().listen((event) async {
        print(event);
        if (event?.email != null) {
          if (event!.emailVerified) {
            await LiziMaterialApp.navigator
                .pushReplacementNamed(DashboardForm.routeName);
          }
        } else if (event?.phoneNumber != null) {
          await LiziMaterialApp.navigator.pushReplacementNamed(
              DashboardForm.routeName);
        } else {
          await LiziMaterialApp.navigator.pushReplacementNamed(
              AuthPage.routeName);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => DashboardCubit()),
              BlocProvider(create: (context) => AuthCubit()),
              BlocProvider(create: (context) => CategoryCubit()),
              BlocProvider(create: (context) => ProductCubit()),
          ],
          child: MaterialApp(
            navigatorKey: LiziMaterialApp._navigatorKey,
            title: 'Lizi',
            debugShowCheckedModeBanner: false,
            scrollBehavior: CustomScrollForWeb(),
            home: const Scaffold(),
            onGenerateRoute: _onGenerateRoute,
          ),
        ));
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case DashboardForm.routeName:
        return DashboardForm.route(settings);
      case DashboardScreen.routeName:
        return DashboardScreen.route(settings);
      case AuthPage.routeName:
        return AuthPage.route(settings);
      case SettingScreen.routeName:
        return SettingScreen.route(settings);
      case CategoryScreen.routeName:
        return CategoryScreen.route(settings);
      case ProductScreen.routeName:
        return ProductScreen.route(settings);
      case WishlistScreen.routeName:
        return WishlistScreen.route(settings);
      case OrderScreen.routeName:
        return OrderScreen.route(settings);
      case CartScreen.routeName:
        return CartScreen.route(settings);

      default:
        return MaterialPageRoute(
          builder: (context) =>
          const Center(
            child: CircularProgressIndicator(),
          ),
        );
    }
  }
}

class CustomScrollForWeb extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices =>
      {PointerDeviceKind.touch, PointerDeviceKind.mouse};
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_integration/cart/screen/cart_screen.dart';
import 'package:firebase_integration/category/screen/category_screen.dart';
import 'package:firebase_integration/dashboard/dashboard_form.dart';
import 'package:firebase_integration/dashboard/screen/dashboardscreen.dart';
import 'package:firebase_integration/authentication/screen/auth_screen.dart';
import 'package:firebase_integration/screens/order_screen.dart';
import 'package:firebase_integration/product/screen/product_screen.dart';
import 'package:firebase_integration/screens/setting_screen.dart';
import 'package:firebase_integration/screens/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RouterScreen extends StatefulWidget {
  const RouterScreen({super.key});

  static final _navigatorKey = GlobalKey<NavigatorState>();

  static NavigatorState get navigator => _navigatorKey.currentState!;

  @override
  State<RouterScreen> createState() => _RouterScreenState();
}

class _RouterScreenState extends State<RouterScreen> {
  @override
  initState() {
    super.initState();
    fetchCurrentUser();
  }

  Future<void> fetchCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final currentUser = prefs.getString('currentUserEmail');
    print('currentUser  $currentUser');
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Navigator(
        initialRoute: auth.currentUser != null
            ? DashboardForm.routeName
            : AuthPage.routeName,
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AuthPage.routeName:
        return AuthPage.route(settings);
      case DashboardForm.routeName:
        return DashboardForm.route(settings);
      case DashboardScreen.routeName:
        return DashboardScreen.route(settings);
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
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
    }
  }
}

import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_integration/authentication/cubit/auth_cubit.dart';
import 'package:firebase_integration/product/cubit/product_cubit.dart';
import 'package:firebase_integration/route/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'category/cubit/category_cubit.dart';
import 'common/global_deps.dart';
import 'dashboard/cubit/dashboard_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  registerGlobalDeps();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: CustomScrollForWeb(),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => DashboardCubit()),
          BlocProvider(create: (context) => AuthCubit()),
          BlocProvider(
              create: (context) =>
                  ProductCubit(categoryCubit: CategoryCubit())),
          BlocProvider(create: (context) => CategoryCubit()),
        ],
        child: const RouterScreen(),
      ),
    );
  }
}

class CustomScrollForWeb extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices =>
      {PointerDeviceKind.touch, PointerDeviceKind.mouse};
}

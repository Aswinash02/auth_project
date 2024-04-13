import 'package:firebase_integration/authentication/cubit/auth_cubit.dart';
import 'package:firebase_integration/category/cubit/category_cubit.dart';
import 'package:get_it/get_it.dart';

/// Global [GetIt] instance
final getIt = GetIt.instance;

/// The global dependencies registration method
void registerGlobalDeps() {
  getIt
    ..registerSingleton<CategoryCubit>(CategoryCubit())
    ..registerSingleton<AuthCubit>(AuthCubit());
}

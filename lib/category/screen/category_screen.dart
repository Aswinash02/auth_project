import 'package:firebase_integration/category/cubit/category_cubit.dart';
import 'package:firebase_integration/category/model.dart';
import 'package:firebase_integration/common/constant/app_colors.dart';
import 'package:firebase_integration/common/constant/app_icon.dart';
import 'package:firebase_integration/common/widget/create_category_model.dart';
import 'package:firebase_integration/common/widget/create_product_model.dart';
import 'package:firebase_integration/common/widget/custom_icon.dart';
import 'package:firebase_integration/dashboard/cubit/dashboard_cubit.dart';
import 'package:firebase_integration/dashboard/widget/category_container.dart';
import 'package:firebase_integration/utils/snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  static const routeName = '/CategoryScreen';

  static Route route(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const CategoryScreen());
  }

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    print('screenWidth $screenWidth');
    final categoryCubit = context.read<CategoryCubit>();
    final dashboardCubit = context.read<DashboardCubit>();

    return BlocConsumer<CategoryCubit, CategoryState>(
      listener: (context, state) {
        if (state is CategoryErrorState) {
          showErrorSnackBar(context: context, message: state.errorMessage!);
        }
      },
      builder: (context, state) {
        return state is CategoryLoadingState
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Scaffold(
                appBar: customAppBar(
                    context: context,
                    controller: categoryCubit.searchController,
                    onChange: categoryCubit.searchCategory,
                    hintText: 'category'),
                body: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: BlocBuilder<CategoryCubit, CategoryState>(
                    builder: (context, state) {
                      return categoryCubit.searchController.text.isNotEmpty &&
                              state.filteredCategory.isEmpty
                          ? const Center(
                              child: Text('Search Category Not Found'),
                            )
                          : StreamBuilder<List<CategoryModel>>(
                              stream: categoryCubit.fetchCategory(),
                              builder: (context,
                                  AsyncSnapshot<List<CategoryModel>> snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.greenAccentColor,
                                    ),
                                  );
                                } else {
                                  return kIsWeb
                                      ? GridView.builder(
                                          itemCount: categoryCubit
                                                  .searchController.text.isEmpty
                                              ? snapshot.data!.length
                                              : state.filteredCategory.length,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            mainAxisExtent: 100,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10,
                                            crossAxisCount: screenWidth > 1300
                                                ? screenWidth > 1400
                                                    ? 10
                                                    : 9
                                                : screenWidth < 1000
                                                    ? screenWidth < 850
                                                        ? screenWidth < 730
                                                            ? screenWidth < 600
                                                                ? 4
                                                                : 5
                                                            : 6
                                                        : 7
                                                    : dashboardCubit
                                                                .enterDrawer &&
                                                            screenWidth < 1200
                                                        ? 7
                                                        : 8,
                                          ),
                                          itemBuilder: (context, index) {
                                            final data = categoryCubit
                                                    .searchController
                                                    .text
                                                    .isEmpty
                                                ? snapshot.data![index]
                                                : state.filteredCategory[index];
                                            return CategoryContainer(
                                                data: data);
                                          },
                                        )
                                      : GridView.builder(
                                          itemCount: categoryCubit
                                                  .searchController.text.isEmpty
                                              ? snapshot.data!.length
                                              : state.filteredCategory.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            mainAxisExtent: 100,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10,
                                            crossAxisCount: 3,
                                          ),
                                          itemBuilder: (context, index) {
                                            final data = categoryCubit
                                                    .searchController
                                                    .text
                                                    .isEmpty
                                                ? snapshot.data![index]
                                                : state.filteredCategory[index];
                                            return CategoryContainer(
                                                data: data);
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

AppBar customAppBar(
    {required BuildContext context,
    required TextEditingController controller,
    required void Function(String) onChange,
    required String hintText}) {
  final categoryCubit = context.read<CategoryCubit>();
  final dashboardState = context.read<DashboardCubit>().state;

  return AppBar(
    automaticallyImplyLeading: false,
    elevation: 0,
    backgroundColor: Colors.transparent,
    centerTitle: true,
    leading: !kIsWeb
        ? IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              AppIcons.arrowBackward,
              color: Colors.black,
              size: 18,
            ),
          )
        : null,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        !categoryCubit.toggle
            ? GestureDetector(
                onTap: () {
                  categoryCubit.toggle = !categoryCubit.toggle;
                },
                child: const Icon(
                  AppIcons.searchIcon,
                  color: AppColors.greenAccentColor,
                ))
            : Container(
                height: 30,
                width: 200,
                color: AppColors.greyShade,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        categoryCubit.toggle = !categoryCubit.toggle;
                      },
                      child: Container(
                        width: 25,
                        height: 30,
                        color: AppColors.greenAccentColor,
                        child: const Icon(
                          AppIcons.arrowForward,
                          size: 15,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        inputFormatters: [NoLeadingSpaceInputFormatter()],
                        cursorColor: AppColors.greenAccentColor,
                        cursorWidth: 1.5,
                        onChanged: onChange,
                        decoration: InputDecoration(
                            focusColor: AppColors.greenAccentColor,
                            border: InputBorder.none,
                            // contentPadding: const EdgeInsets.only(bottom: 23.0),
                            prefixIcon: const Icon(
                              AppIcons.searchIcon,
                              size: 20,
                              color: AppColors.greenAccentColor,
                            ),
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  categoryCubit.searchController.clear();
                                },
                                child: Icon(
                                  categoryCubit.searchController.text == ''
                                      ? null
                                      : AppIcons.clearIcon,
                                  size: 15,
                                  color: AppColors.greenAccentColor,
                                )),
                            hintText: 'Search $hintText',
                            hintStyle: const TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ),
        const SizedBox(
          width: 10,
        ),
        dashboardState.userType == UserType.admin
            ? GestureDetector(
                onTap: () {
                  hintText == 'category'
                      ? showCustomBottomSheet(context)
                      : productModel(context);
                },
                child: CustomIcon(
                    color: AppColors.greyShade, icon: AppIcons.addIcon))
            : Container(),
      ],
    ),
  );
}

class NoLeadingSpaceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty && newValue.text.startsWith(' ')) {
      final trimmedText = newValue.text.trimLeft();
      return TextEditingValue(
        text: trimmedText,
        selection: TextSelection.collapsed(offset: trimmedText.length),
      );
    }
    return newValue;
  }
}

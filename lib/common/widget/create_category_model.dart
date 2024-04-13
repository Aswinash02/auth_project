import 'package:firebase_integration/category/cubit/category_cubit.dart';
import 'package:firebase_integration/common/constant/app_colors.dart';
import 'package:firebase_integration/common/constant/app_icon.dart';
import 'package:firebase_integration/common/widget/custom_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bottom_button.dart';

Future showCustomBottomSheet(BuildContext context) {
  final categoryCubit = context.read<CategoryCubit>();
  if (categoryCubit.state.selectedCategory.name != '') {
    categoryCubit.categoryController.text =
        categoryCubit.state.selectedCategory.name;
  }
  return showModalBottomSheet(
    context: context,
    isDismissible: false,
    builder: (BuildContext context) {
      return SizedBox(
        width: 240,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        categoryCubit.emitEmpty();
                      },
                      child: const Icon(AppIcons.clearIcon))),
            kIsWeb?  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      BlocBuilder<CategoryCubit, CategoryState>(
                        builder: (context, state) {
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 1,
                                color: AppColors.greenAccentColor,
                              ),
                            ),
                            height: 100,
                            width: 100,
                            child: categoryCubit.state.pickedImage.path != ''
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      state.pickedImage.path,
                                      fit: BoxFit.fill,
                                    ),
                                  )
                                : categoryCubit
                                            .state.selectedCategory.imageUrl !=
                                        ''
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          state.selectedCategory.imageUrl,
                                          fit: BoxFit.fill,
                                        ),
                                      )
                                    : Container(), // Empty container if no image is selected
                          );
                        },
                      ),
                      Positioned(
                          right: 4,
                          bottom: 0,
                          child: GestureDetector(
                              onTap: () async {
                                categoryCubit.pickImage();
                              },
                              child: const Icon(AppIcons.photoCameraIcon)))
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 500,
                    child: CustomTextField(
                      controller: categoryCubit.categoryController,
                      onChanged: (value) {},
                      hintText: 'Category Name',
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  categoryCubit.state.selectedCategory.name != '' ||
                          categoryCubit.state.selectedCategory.imageUrl != ''
                      ? BlocBuilder<CategoryCubit, CategoryState>(
                          builder: (context, state) {
                            return state is CategoryLoadingState
                                ? const CircularProgressIndicator()
                                : bottomButton(
                                    buttonText: 'Update',
                                    onTap: () async {
                                      await categoryCubit.updateCategory();
                                      Navigator.pop(context);
                                    },
                                    disable: state.selectedCategory.name ==
                                        categoryCubit.categoryController.text);
                          },
                        )
                      : BlocBuilder<CategoryCubit, CategoryState>(
                          builder: (context, state) {
                            return state is CategoryLoadingState
                                ? const CircularProgressIndicator()
                                : bottomButton(
                                    buttonText: 'Create',
                                    onTap: () async {
                                      await categoryCubit.createCategory();
                                      Navigator.pop(context);
                                    },
                                    disable: categoryCubit.isOneFieldEmpty());
                          },
                        )
                ],
              ):Column(
              children: [
                Stack(
                  children: [
                    BlocBuilder<CategoryCubit, CategoryState>(
                      builder: (context, state) {
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 1,
                              color: AppColors.greenAccentColor,
                            ),
                          ),
                          height: 100,
                          width: 100,
                          child: categoryCubit.state.pickedImage.path != ''
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              state.pickedImage.path,
                              fit: BoxFit.fill,
                            ),
                          )
                              : categoryCubit
                              .state.selectedCategory.imageUrl !=
                              ''
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              state.selectedCategory.imageUrl,
                              fit: BoxFit.fill,
                            ),
                          )
                              : Container(), // Empty container if no image is selected
                        );
                      },
                    ),
                    Positioned(
                        right: 4,
                        bottom: 0,
                        child: GestureDetector(
                            onTap: () async {
                              categoryCubit.pickImage();
                            },
                            child: const Icon(AppIcons.photoCameraIcon)))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 500,
                  child: CustomTextField(
                    controller: categoryCubit.categoryController,
                    onChanged: (value) {},
                    hintText: 'Category Name',
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                categoryCubit.state.selectedCategory.name != '' ||
                    categoryCubit.state.selectedCategory.imageUrl != ''
                    ? BlocBuilder<CategoryCubit, CategoryState>(
                  builder: (context, state) {
                    return state is CategoryLoadingState
                        ? const CircularProgressIndicator()
                        : bottomButton(
                        buttonText: 'Update',
                        onTap: () async {
                          await categoryCubit.updateCategory();
                          Navigator.pop(context);
                        },
                        disable: state.selectedCategory.name ==
                            categoryCubit.categoryController.text);
                  },
                )
                    : BlocBuilder<CategoryCubit, CategoryState>(
                  builder: (context, state) {
                    return state is CategoryLoadingState
                        ? const CircularProgressIndicator()
                        : bottomButton(
                        buttonText: 'Create',
                        onTap: () async {
                          await categoryCubit.createCategory();
                          Navigator.pop(context);
                        },
                        disable: categoryCubit.isOneFieldEmpty());
                  },
                )
              ],
            ),
            ],
          ),
        ),
      );
    },
  );
}

import 'package:firebase_integration/category/screen/category_screen.dart';
import 'package:firebase_integration/common/constant/app_colors.dart';
import 'package:firebase_integration/common/constant/app_icon.dart';
import 'package:firebase_integration/common/widget/bottom_button.dart';
import 'package:firebase_integration/common/widget/custom_text_field.dart';
import 'package:firebase_integration/product/cubit/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future productModel(BuildContext context) {
  final productCubit = context.read<ProductCubit>();
  if (productCubit.state.selectedProduct.productName != '') {
    productCubit.productController.text =
        productCubit.state.selectedProduct.productName;
    productCubit.categoryNameController.text =
        productCubit.state.selectedProduct.categoryName;
    productCubit.descriptionController.text =
        productCubit.state.selectedProduct.description;
    productCubit.priceController.text =
        productCubit.state.selectedProduct.price.toString();
    productCubit.unitController.text =
        productCubit.state.selectedProduct.unit!;
  }
  if (productCubit.state.selectedCategory != '') {
    productCubit.categoryNameController.text =
        productCubit.state.selectedCategory;
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
                        productCubit.emitEmpty();
                      },
                      child: const Icon(AppIcons.clearIcon))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      BlocBuilder<ProductCubit, ProductState>(
                        builder: (context, state) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                width: 1,
                                color: AppColors.greenAccentColor,
                              ),
                            ),
                            height: 200,
                            width: 150,
                            child: productCubit.state.pickedImage.path != ''
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      state.pickedImage.path,
                                      fit: BoxFit.fill,
                                    ),
                                  )
                                : productCubit.state.selectedProduct.imageUrl !=
                                        ''
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          state.selectedProduct.imageUrl,
                                          fit: BoxFit.fill,
                                        ),
                                      )
                                    : Container(), // Empty container if no image is selected
                          );
                        },
                      ),
                      Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                              onTap: () async {
                                productCubit.pickImage();
                              },
                              child: const Icon(AppIcons.photoCameraIcon)))
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 245,
                            child: CustomTextField(
                              controller: productCubit.productController,
                              onChanged: (value) {},
                              hintText: 'Product Name',
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),SizedBox(
                            width: 245,
                            child: CustomTextField(
                              controller: productCubit.categoryNameController,
                              readOnly: true,
                              onChanged: (value) {},
                              hintText: 'CategoryName',
                            ),
                          )

                        ],
                      ),const SizedBox(
                        height: 10,
                      ),Row(
                        children: [
                          SizedBox(
                            width: 245,
                            child: CustomTextField(
                              controller: productCubit.priceController,
                              onChanged: (value) {},
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                              hintText: 'Price',
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),SizedBox(
                            width: 245,
                            child: CustomTextField(
                              controller: productCubit.unitController,
                              onChanged: (value) {},
                              hintText: 'Unit',
                            ),
                          ),

                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 500,
                        child: CustomTextField(
                          controller: productCubit.descriptionController,
                          onChanged: (value) {},
                          hintText: 'Description',
                        ),
                      ),


                      const SizedBox(
                        height: 15,
                      ),
                      productCubit.state.selectedProduct.productName != '' ||
                              productCubit.state.selectedProduct.description !=
                                  '' ||
                              productCubit.state.selectedProduct.categoryName !=
                                  ''
                          ? BlocBuilder<ProductCubit, ProductState>(
                              builder: (context, state) {
                                return state is ProductLoadingState
                                    ? const CircularProgressIndicator()
                                    : bottomButton(
                                        buttonText: 'Update',
                                        onTap: () async {
                                          await productCubit.updateProduct();
                                          Navigator.pop(context);
                                        },
                                        disable: productCubit.checkFieldChange());
                              },
                            )
                          : BlocBuilder<ProductCubit, ProductState>(
                              builder: (context, state) {
                                return state is ProductLoadingState
                                    ? const CircularProgressIndicator()
                                    : bottomButton(
                                        buttonText: 'Create',
                                        onTap: () async {
                                          await productCubit.createProduct();
                                          Navigator.pop(context);
                                        },
                                        disable:
                                            productCubit.isOneFieldEmpty());
                              },
                            )
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  (productCubit.state.selectedProduct.productName != '' ||
                              productCubit.state.selectedProduct.description !=
                                  '' ||
                              productCubit.state.selectedProduct.categoryName !=
                                  '') ||
                          productCubit.state.selectedCategory != ''
                      ? Container()
                      : SizedBox(
                          height: 200,
                          width: 180,
                          child: Column(
                            children: [
                              Container(
                                height: 30,
                                width: 180,
                                color: AppColors.greyShade,
                                child: TextField(
                                  controller: productCubit.searchController,
                                  inputFormatters: [
                                    NoLeadingSpaceInputFormatter()
                                  ],
                                  cursorColor: AppColors.greenAccentColor,
                                  cursorWidth: 1.5,
                                  onChanged: productCubit.searchCategory,
                                  decoration: InputDecoration(
                                      focusColor: AppColors.greenAccentColor,
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.all(0.0),
                                      prefixIcon: const Icon(
                                        AppIcons.searchIcon,
                                        size: 20,
                                        color: AppColors.greenAccentColor,
                                      ),
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            productCubit.searchController
                                                .clear();
                                          },
                                          child: Icon(
                                            productCubit.searchController
                                                        .text ==
                                                    ''
                                                ? null
                                                : AppIcons.clearIcon,
                                            size: 15,
                                            color: AppColors.greenAccentColor,
                                          )),
                                      hintText: 'Search category'),
                                ),
                              ),
                              BlocBuilder<ProductCubit, ProductState>(
                                builder: (context, state) {
                                  return Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: ListView.builder(
                                        itemCount: productCubit
                                                .searchController.text.isEmpty
                                            ? productCubit
                                                .state.categoryNameList.length
                                            : productCubit
                                                .state.filteredCategory.length,
                                        itemBuilder: (context, index) {
                                          final data = productCubit
                                                  .searchController.text.isEmpty
                                              ? productCubit
                                                  .state.categoryNameList[index]
                                              : productCubit.state
                                                  .filteredCategory[index];
                                          return GestureDetector(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 4.0),
                                              child: Text(data),
                                            ),
                                            onTap: () {
                                              productCubit
                                                  .categoryNameController
                                                  .text = data;
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
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

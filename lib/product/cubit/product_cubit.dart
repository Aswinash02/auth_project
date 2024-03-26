import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_integration/category/cubit/category_cubit.dart';
import 'package:firebase_integration/category/model.dart';
import 'package:firebase_integration/product/model/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit({required this.categoryCubit})
      : super(ProductInitial(
            productList: const [],
            webPickedImage: Uint8List.fromList([0]),
            selectedProduct: const ProductModel(
                imageUrl: '',
                id: '',
                productName: '',
                categoryName: '',
                description: '',
                wishlist: false),
            pickedImage: File(''),
            categoryNameList: const [],
            selectedCategory: '',
            filteredCategory: const [],
            wishlist: false,
            productWishlist: const [],
            filteredProducts: []));

  final productController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryNameController = TextEditingController();
  final searchController = TextEditingController();
  final amountController = TextEditingController();
  final imagePicker = ImagePicker();
  final db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  // final categoryCubit = getIt.get<CategoryCubit>();
  final CategoryCubit categoryCubit;

  Future<void> pickImage() async {
    if (kIsWeb) {
      final image = await imagePicker.pickImage(source: ImageSource.gallery);
      final byteImage = await image?.readAsBytes();
      final webImage = File(image!.path);
      emit(state.copyWith(pickedImage: webImage, webPickedImage: byteImage));
    }
  }

  Stream<List<ProductModel>> fetchProduct() {
    try {
      return db.collection('product').snapshots().map(
        (querySnapshot) {
          final dataList = querySnapshot.docs.map((doc) {
            return ProductModel.fromJson(doc);
          }).toList();
          emit(state.copyWith(productList: dataList));
          filterProducts(state.selectedCategory);
          fetchWishlist();
          return dataList;
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  void fetchWishlist() {
    List<ProductModel> wishlistList = [];
    for (int i = 0; i < state.productList.length; i++) {
      if (state.productList[i].wishlist) {
        wishlistList.add(state.productList[i]);
      }
    }
    emit(state.copyWith(productWishlist: wishlistList));
  }

  Future<void> createProduct() async {
    try {
      setLoadingState();
      Reference storageReference =
          storage.ref().child('ProductImage/${DateTime.now()}.png');
      await storageReference.putData(state.webPickedImage);
      String downloadUrl = await storageReference.getDownloadURL();
      Map<String, dynamic> body = {
        'id': db.collection('product').doc().id,
        'name': productController.text,
        'description': descriptionController.text,
        'categoryName': categoryNameController.text,
        'wishlist': false,
        'imageUrl': downloadUrl
      };
      await db.collection('product').add(body);
    } catch (e) {
      errorState(e.toString());
    } finally {
      print('yest entered');
      emitEmpty();
      setLoadedState();
    }
  }

  Future<void> updateProduct() async {
    try {
      setLoadingState();
      String downloadUrl = state.selectedProduct.imageUrl;
      if (state.pickedImage.path != '') {
        Reference storageReference =
            storage.ref().child('ProductImage/${DateTime.now()}.png');
        await storageReference.putData(state.webPickedImage);
        downloadUrl = await storageReference.getDownloadURL();
      }

      Map<String, dynamic> body = {
        'id': state.selectedProduct.id,
        'name': productController.text,
        'categoryName': categoryNameController.text,
        'description': descriptionController.text,
        'wishlist': state.selectedProduct.wishlist,
        'imageUrl': downloadUrl
      };
      await db.collection('product').doc(state.selectedProduct.id).update(body);
    } catch (e) {
      print('error    ${e.toString()} ');
      errorState(e.toString());
    } finally {
      emitEmpty();
      setLoadedState();
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      setLoadingState();
      await db.collection('product').doc(id).delete();
    } catch (e) {
      errorState(e.toString());
    } finally {
      setLoadedState();
    }
  }

  void filterProducts(String categoryName) {
    final List<ProductModel> filteredProducts = [];

    for (var i = 0; i < state.productList.length; i++) {
      if (state.productList[i].categoryName == categoryName) {
        filteredProducts.add(state.productList[i]);
      }
    }
    emit(state.copyWith(
        filteredProducts: filteredProducts, selectedCategory: categoryName));
  }

  void emitEmptyCategory(String categoryName) {
    emit(state.copyWith(selectedCategory: categoryName));
  }

  void fetchCategoryName(List<CategoryModel> data) {
    List<String> categoryNameList = [];
    for (int i = 0; i < data.length; i++) {
      categoryNameList.add(data[i].name);
    }

    emit(state.copyWith(categoryNameList: categoryNameList));
  }

  void emitEmpty() {
    productController.clear();
    descriptionController.clear();
    categoryNameController.clear();
    emit(state.copyWith(
        pickedImage: File(''),
        selectedProduct: const ProductModel(
            imageUrl: '',
            id: '',
            productName: '',
            categoryName: '',
            description: '',
            wishlist: false)));
  }

  void emitSelectedProduct(ProductModel data) {
    emit(state.copyWith(selectedProduct: data));
  }

  void setLoadedState() {
    emit(ProductLoadedState(
        productList: state.productList,
        webPickedImage: state.webPickedImage,
        selectedProduct: state.selectedProduct,
        pickedImage: state.pickedImage,
        categoryNameList: state.categoryNameList,
        selectedCategory: state.selectedCategory,
        filteredCategory: state.filteredCategory,
        wishlist: state.wishlist,
        productWishlist: state.productWishlist,
        filteredProducts: state.filteredProducts));
  }

  void errorState(String message) {
    emit(ProductErrorState(
        productList: state.productList,
        webPickedImage: state.webPickedImage,
        selectedProduct: state.selectedProduct,
        pickedImage: state.pickedImage,
        message: message,
        categoryNameList: state.categoryNameList,
        selectedCategory: state.selectedCategory,
        filteredCategory: state.filteredCategory,
        wishlist: state.wishlist,
        productWishlist: state.productWishlist,
        filteredProducts: state.filteredProducts));
  }

  void setLoadingState() {
    emit(ProductLoadingState(
        productList: state.productList,
        webPickedImage: state.webPickedImage,
        selectedProduct: state.selectedProduct,
        pickedImage: state.pickedImage,
        categoryNameList: state.categoryNameList,
        selectedCategory: state.selectedCategory,
        filteredCategory: state.filteredCategory,
        wishlist: state.wishlist,
        productWishlist: state.productWishlist,
        filteredProducts: state.filteredProducts));
  }

  ProductModel empty() {
    return const ProductModel(
        imageUrl: '',
        id: '',
        productName: '',
        categoryName: '',
        description: '',
        wishlist: false);
  }

  bool isOneFieldEmpty() {
    return productController.text.isEmpty ||
        state.pickedImage.path == '' ||
        descriptionController.text.isEmpty ||
        categoryNameController.text.isEmpty;
  }

  void searchCategory(String value) {
    final searchCategory = state.categoryNameList
        .where((element) =>
            element.toLowerCase().trim().startsWith(value.toLowerCase().trim()))
        .toList();
    emit(state.copyWith(filteredCategory: searchCategory));
  }

  Future<void> addWishlistProduct(ProductModel data) async {
    try {
      setLoadingState();
      emit(state.copyWith(wishlist: !state.wishlist));
      Map<String, dynamic> body = {
        'wishlist': state.wishlist,
      };
      await db.collection('product').doc(data.id).update(body);
      if (!state.wishlist) {
        List<ProductModel> removeWishlist = [...state.productWishlist];
        for (var element in state.productWishlist) {
          if (element.id == data.id) {
            removeWishlist.remove(data);
            break;
          }
        }
        emit(state.copyWith(productWishlist: removeWishlist));
      }

      // if (state.wishlist) {
      //   await db
      //       .collection('wishlist')
      //       .doc(data.id)
      //       .set({'wishlistProductId': data.id});
      // } else {
      //   await db.collection('wishlist').doc(data.id).delete();
      // }
    } catch (e) {
      print(e.toString());
    } finally {
      setLoadedState();
    }
  }

  void removeWishlistProduct() {}
}

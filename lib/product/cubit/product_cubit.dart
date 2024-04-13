import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_integration/category/cubit/category_cubit.dart';
import 'package:firebase_integration/category/model.dart';
import 'package:firebase_integration/product/model/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  final productController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryNameController = TextEditingController();
  final priceController = TextEditingController();
  final searchProductCon = TextEditingController();
  final unitController = TextEditingController();
  final searchController = TextEditingController();
  final amountController = TextEditingController();
  final imagePicker = ImagePicker();
  final db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

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
        'unit': unitController.text,
        'price':int.parse(priceController.text) ,
        'imageUrl': downloadUrl
      };
      await db.collection('product').add(body);
    } catch (e) {
      print(e);
      errorState(e.toString());
    } finally {
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
        'price': double.parse(priceController.text),
        'unit': unitController.text,
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
    unitController.clear();
    priceController.clear();
    emit(state.copyWith(
        pickedImage: File(''),
        selectedProduct: const ProductModel(
            imageUrl: '',
            unit: '',
            id: '',
            productName: '',
            categoryName: '',
            description: '',
            wishlist: false,
            price: 0.0)));
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
        filteredProducts: state.filteredProducts,
        searchProducts: state.searchProducts));
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
        filteredProducts: state.filteredProducts,
        searchProducts: state.searchProducts));
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
        filteredProducts: state.filteredProducts,
        searchProducts: state.searchProducts));
  }

  ProductModel empty() {
    return const ProductModel(
        imageUrl: '',
        id: '',
        productName: '',
        unit: '',
        categoryName: '',
        description: '',
        wishlist: false,
        price: 0.0);
  }

  bool isOneFieldEmpty() {
    return productController.text.isEmpty ||
        state.pickedImage.path == '' ||
        descriptionController.text.isEmpty ||
        categoryNameController.text.isEmpty ||
        unitController.text.isEmpty ||
        priceController.text.isEmpty;
  }

  bool checkFieldChange() {
    return state.selectedProduct.productName == productController.text &&
        state.selectedProduct.description == descriptionController.text &&
        state.selectedProduct.unit == unitController.text &&
        state.selectedProduct.price.toString() == priceController.text;
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
      emit(state.copyWith(wishlist: !data.wishlist));
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
      // emit(state.copyWith(wishlist: !state.wishlist));
      // Map<String, dynamic> productData = data.toJson();
      // final productDataList = state.productWishlist.map((e) => e.toJson());
      // await db
      //     .collection('wishlist')
      //     .doc(FirebaseAuth.instance.currentUser?.uid)
      //     .set({
      // 'wishlistProduct': [...productDataList]});
      // if (!data.wishlist) {
      //   await db
      //       .collection('wishlist')
      //       .doc(FirebaseAuth.instance.currentUser?.uid)
      //       .set({
      //     'wishlistProduct': [...productDataList]
      //   });
      // } else {
      //   await db
      //       .collection('wishlist')
      //       .doc(FirebaseAuth.instance.currentUser?.uid)
      //       .update({'0' : FieldValue.delete()});
      // }
    } catch (e) {
      print(e.toString());
    } finally {
      setLoadedState();
    }
  }

  void searchProduct(String value) {
    final searchProducts = state.productList
        .where((product) => product.productName
            .toLowerCase()
            .trim()
            .startsWith(value.toLowerCase().trim()))
        .toList();
    emit(state.copyWith(searchProducts: searchProducts));
  }

  void searchFilteredProduct(String value) {
    final searchProducts = state.filteredProducts
        .where((product) => product.productName
            .toLowerCase()
            .trim()
            .startsWith(value.toLowerCase().trim()))
        .toList();
    emit(state.copyWith(searchProducts: searchProducts));
  }

  void removeWishlistProduct() {}

  // void addToCart() {
  //   emit(state.copyWith(cartProductCount: state.cartProductCount + 1));
  // }

  Future<void> removeToCart({required ProductModel data}) async {
    emit(state.copyWith(cartProductCount: state.cartProductCount - 1));
    if (data.productName == db.collection('cart').doc().path) {
      final body = {'quantity': state.cartProductCount};
      await db.collection('cart').doc(data.productName).set(body);
    } else {
      final body = {
        'product': data.toJson(),
        'quantity': state.cartProductCount
      };
      await db.collection('cart').doc(data.productName).set(body);
    }

  }

  void addToCart({required ProductModel data}) async {
    emit(state.copyWith(cartProductCount: state.cartProductCount + 1));
    if (data.productName == db.collection('cart').doc().path) {
      final body = {'quantity': state.cartProductCount};
      await db.collection('cart').doc(data.productName).set(body);
    } else {
      final body = {
        'product': data.toJson(),
        'quantity': state.cartProductCount
      };
      await db.collection('cart').doc(data.productName).set(body);
    }
  }

  Future<void> fetchCartProduct({required ProductModel data}) async {
    emit(state.copyWith(selectedProduct: data, cartProductCount: 0));
    final cartCount = await db
        .collection('cart')
        .doc(state.selectedProduct.productName)
        .get();
    emit(state.copyWith(cartProductCount: cartCount['quantity']));
  }
}

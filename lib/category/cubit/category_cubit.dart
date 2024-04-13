import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_integration/category/model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit()
      : super(CategoryInitial(
            categoryList: const [],
            selectedCategory:
                const CategoryModel(id: '', name: '', imageUrl: ''),
            // errorMessage: '',
            pickedImage: File(''),
            filteredCategory: const [],
            webPickedImage: Uint8List.fromList([0]),
            selectedCategoryName: ''));
  final categoryController = TextEditingController();
  final searchController = TextEditingController();
   bool toggle=false;
  final db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  Future<void> pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    final image = File(pickedFile!.path);
    final byteImage = await pickedFile.readAsBytes();
    emit(state.copyWith(pickedImage: image, webPickedImage: byteImage));
  }

  // Future<void> fetchCategory() async {
  //   try {
  //     setLoadingState();
  //     final jsonData = await db.collection('category').get();
  //     final dataList =
  //         jsonData.docs.map((data) => CategoryModel.fromJson(data)).toList();
  //     emit(state.copyWith(categoryList: dataList));
  //   } catch (e) {
  //     errorState(e.toString());
  //   } finally {
  //     setLoadedState();
  //   }
  // }

  Stream<List<CategoryModel>> fetchCategory() {

    try {
      return db.collection('category').snapshots().map(
        (querySnapshot) {
          final dataList = querySnapshot.docs.map((doc) {
            return CategoryModel.fromJson(doc);
          }).toList();
          emit(state.copyWith(categoryList: dataList));
          return dataList;
        },
      );
    } catch (e) {

      errorState(e.toString());
      rethrow;
    }
  }

  Future<void> createCategory() async {
    try {
      setLoadingState();
      Reference storageReference =
          storage.ref().child('CategoryImage/${DateTime.now()}.png');
      await storageReference.putData(state.webPickedImage);
      String downloadUrl = await storageReference.getDownloadURL();
      Map<String, dynamic> body = {
        'id': db.collection('category').doc().id,
        'name': categoryController.text,
        'imageUrl': downloadUrl
      };
      await db.collection('category').add(body);
    } catch (e) {
      errorState(e.toString());
    } finally {
      emitEmpty();
      setLoadedState();
    }
  }

  Future<void> updateCategory() async {
    try {
      setLoadingState();
      String downloadUrl = state.selectedCategory.imageUrl;
      if (state.pickedImage.path != '') {
        Reference storageReference =
            storage.ref().child('CategoryImage/${DateTime.now()}.png');
        await storageReference.putData(state.webPickedImage);
        downloadUrl = await storageReference.getDownloadURL();
      }

      Map<String, dynamic> body = {
        'id': state.selectedCategory.id,
        'name': categoryController.text,
        'imageUrl': downloadUrl
      };
      await db
          .collection('category')
          .doc(state.selectedCategory.id)
          .update(body);
    } catch (e) {
      errorState(e.toString());
    } finally {
      emitEmpty();
      setLoadedState();
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      setLoadingState();
      await db.collection('category').doc(id).delete();
    } catch (e) {
      errorState(e.toString());
    } finally {
      setLoadedState();
    }
  }

  void emitCategoryDetails({required CategoryModel data}) {
    emit(ShowBottomSheet(
        categoryList: state.categoryList,
        selectedCategory: state.selectedCategory,
        // errorMessage: state.errorMessage,
        pickedImage: state.pickedImage,
        filteredCategory: state.filteredCategory,
        webPickedImage: state.webPickedImage,
        selectedCategoryName: state.selectedCategoryName));
    emit(
      state.copyWith(
        selectedCategory: CategoryModel(
            id: data.id, name: data.name, imageUrl: data.imageUrl),
      ),
    );
  }

  void searchCategory(String value) {
    final searchCategory = state.categoryList
        .where((element) => element.name
            .toLowerCase()
            .trim()
            .startsWith(value.toLowerCase().trim()))
        .toList();
    emit(state.copyWith(filteredCategory: searchCategory));
  }

  void emitCategoryName(String name) {
    emit(state.copyWith(selectedCategoryName: name));
  }

  void emitEmpty() {
    categoryController.clear();
    emit(state.copyWith(
        selectedCategory: const CategoryModel(id: '', name: '', imageUrl: ''),
        pickedImage: File('')));
  }

  bool isOneFieldEmpty() {
    return categoryController.text.isEmpty || state.pickedImage.path == '';
  }

  void onChangeText(String name) {
    emit(state.copyWith(onChangeText: name));
  }

  void setLoadingState() {
    emit(CategoryLoadingState(
        categoryList: state.categoryList,
        selectedCategory: state.selectedCategory,
        // errorMessage: state.errorMessage,
        pickedImage: state.pickedImage,
        filteredCategory: state.filteredCategory,
        webPickedImage: state.webPickedImage,
        selectedCategoryName: state.selectedCategoryName));
  }

  void setLoadedState() {
    emit(CategoryLoadedState(
        categoryList: state.categoryList,
        selectedCategory: state.selectedCategory,
        // errorMessage: state.errorMessage,
        pickedImage: state.pickedImage,
        filteredCategory: state.filteredCategory,
        webPickedImage: state.webPickedImage,
        selectedCategoryName: state.selectedCategoryName));
  }

  void errorState(String message) {
    emit(CategoryErrorState(
        categoryList: state.categoryList,
        selectedCategory: state.selectedCategory,
        errorMessage: message,
        pickedImage: state.pickedImage,
        filteredCategory: state.filteredCategory,
        webPickedImage: state.webPickedImage,
        selectedCategoryName: state.selectedCategoryName));
  }
}

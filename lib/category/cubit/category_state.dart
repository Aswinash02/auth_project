part of 'category_cubit.dart';

class CategoryState extends Equatable {
  const CategoryState({
    required this.categoryList,
    required this.pickedImage,
    this.onChangeText,
    required this.selectedCategoryName,
    required this.webPickedImage,
    required this.filteredCategory,
    this.errorMessage,
    required this.selectedCategory,
  });

  final CategoryModel selectedCategory;
  final String? onChangeText;
  final String? errorMessage;
  final File pickedImage;
  final String selectedCategoryName;
  final Uint8List webPickedImage;
  final List<CategoryModel> categoryList;
  final List<CategoryModel> filteredCategory;

  @override
  List<Object?> get props => [
        categoryList,
        pickedImage,
        selectedCategory,
        filteredCategory,
        errorMessage,
        onChangeText,
        webPickedImage,
        selectedCategoryName
      ];

  CategoryState copyWith(
      {List<CategoryModel>? categoryList,
      File? pickedImage,
      CategoryModel? selectedCategory,
      String? onChangeText,
      String? errorMessage,
      Uint8List? webPickedImage,
      String? selectedCategoryName,
      List<CategoryModel>? filteredCategory}) {
    return CategoryState(
        selectedCategoryName: selectedCategoryName ?? this.selectedCategoryName,
        categoryList: categoryList ?? this.categoryList,
        pickedImage: pickedImage ?? this.pickedImage,
        onChangeText: onChangeText ?? this.onChangeText,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        filteredCategory: filteredCategory ?? this.filteredCategory,
        webPickedImage: webPickedImage ?? this.webPickedImage,
        errorMessage: errorMessage ?? this.errorMessage);
  }
}

class CategoryInitial extends CategoryState {
  const CategoryInitial({
    required super.categoryList,
    required super.selectedCategory,
    // required super.errorMessage,
    required super.pickedImage,
    required super.filteredCategory,
    required super.webPickedImage,
    required super.selectedCategoryName,
  });
}

class CategoryEmptyState extends CategoryState {
  const CategoryEmptyState({
    required super.categoryList,
    required super.selectedCategory,
    // required super.errorMessage,
    required super.pickedImage,
    required super.filteredCategory,
    required super.webPickedImage,
    required super.selectedCategoryName,
  });
}

class CategoryLoadingState extends CategoryState {
  const CategoryLoadingState({
    required super.categoryList,
    required super.selectedCategory,
    // required super.errorMessage,
    required super.pickedImage,
    required super.filteredCategory,
    required super.webPickedImage,
    required super.selectedCategoryName,
  });
}

class CategoryLoadedState extends CategoryState {
  const CategoryLoadedState({
    required super.categoryList,
    required super.selectedCategory,
    // required super.errorMessage,
    required super.pickedImage,
    required super.filteredCategory,
    required super.webPickedImage,
    required super.selectedCategoryName,
  });
}

class CategoryErrorState extends CategoryState {
  const CategoryErrorState({
    required super.categoryList,
    required super.selectedCategory,
    required super.errorMessage,
    required super.pickedImage,
    required super.filteredCategory,
    required super.webPickedImage,
    required super.selectedCategoryName,
  });
}

class ShowBottomSheet extends CategoryState {
  const ShowBottomSheet({
    required super.categoryList,
    required super.selectedCategory,
    // required super.errorMessage,
    required super.pickedImage,
    required super.filteredCategory,
    required super.webPickedImage,
    required super.selectedCategoryName,
  });
}

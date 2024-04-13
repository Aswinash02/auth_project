part of 'product_cubit.dart';

class ProductState extends Equatable {
  const ProductState(
      {required this.productList,
      required this.pickedImage,
      required this.webPickedImage,
      required this.selectedProduct,
      required this.selectedCategory,
      required this.categoryNameList,
      required this.filteredCategory,
      required this.searchProducts,
      required this.productWishlist,
      required this.wishlist,
      required this.filteredProducts,
      this.cartProductCount = 0});

  final Uint8List webPickedImage;
  final List<ProductModel> productList;
  final List<ProductModel> productWishlist;
  final List<ProductModel> filteredProducts;
  final List<ProductModel> searchProducts;
  final ProductModel selectedProduct;
  final File pickedImage;
  final String selectedCategory;
  final List<String> categoryNameList;
  final List<String> filteredCategory;
  final bool wishlist;
  final int cartProductCount;

  ProductState copyWith(
      {Uint8List? webPickedImage,
      List<ProductModel>? productList,
      ProductModel? selectedProduct,
      File? pickedImage,
      List<ProductModel>? filteredProducts,
      List<String>? filteredCategory,
      List<String>? categoryNameList,
      String? selectedCategory,
      List<ProductModel>? productWishlist,
      List<ProductModel>? searchProducts,
      int? cartProductCount,
      bool? wishlist}) {
    return ProductState(
        pickedImage: pickedImage ?? this.pickedImage,
        webPickedImage: webPickedImage ?? this.webPickedImage,
        selectedProduct: selectedProduct ?? this.selectedProduct,
        productList: productList ?? this.productList,
        filteredProducts: filteredProducts ?? this.filteredProducts,
        categoryNameList: categoryNameList ?? this.categoryNameList,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        filteredCategory: filteredCategory ?? this.filteredCategory,
        wishlist: wishlist ?? this.wishlist,
        cartProductCount: cartProductCount ?? this.cartProductCount,
        productWishlist: productWishlist ?? this.productWishlist,
        searchProducts: searchProducts ?? this.searchProducts);
  }

  @override
  List<Object?> get props => [
        webPickedImage,
        productList,
        filteredProducts,
        selectedProduct,
        categoryNameList,
        selectedCategory,
        filteredCategory,
        wishlist,
        productWishlist,
        searchProducts,
        cartProductCount
      ];
}

class ProductInitial extends ProductState {
  ProductInitial()
      : super(
            productList: const [],
            webPickedImage: Uint8List.fromList([0]),
            selectedProduct: const ProductModel(
                imageUrl: '',
                id: '',
                unit: '',
                productName: '',
                categoryName: '',
                description: '',
                wishlist: false,
                price: 0.0),
            pickedImage: File(''),
            categoryNameList: const [],
            selectedCategory: '',
            filteredCategory: const [],
            wishlist: false,
            productWishlist: const [],
            filteredProducts: const [],
            searchProducts: const []);
}

class ProductLoadingState extends ProductState {
  const ProductLoadingState(
      {required super.productList,
      required super.webPickedImage,
      required super.selectedProduct,
      required super.pickedImage,
      required super.categoryNameList,
      required super.selectedCategory,
      required super.filteredCategory,
      required super.wishlist,
      required super.productWishlist,
      required super.filteredProducts,
      required super.searchProducts});
}

class ProductLoadedState extends ProductState {
  const ProductLoadedState(
      {required super.productList,
      required super.webPickedImage,
      required super.selectedProduct,
      required super.pickedImage,
      required super.categoryNameList,
      required super.selectedCategory,
      required super.filteredCategory,
      required super.wishlist,
      required super.productWishlist,
      required super.filteredProducts,
      required super.searchProducts});
}

class ProductErrorState extends ProductState {
  const ProductErrorState({
    required super.productList,
    required super.webPickedImage,
    required super.selectedProduct,
    required super.pickedImage,
    required this.message,
    required super.categoryNameList,
    required super.selectedCategory,
    required super.filteredCategory,
    required super.wishlist,
    required super.productWishlist,
    required super.filteredProducts,
    required super.searchProducts,
  });

  final String message;
}

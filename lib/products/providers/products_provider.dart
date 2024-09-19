import 'package:ecom/products/models/products.dart';
import 'package:ecom/products/repo/products_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsController {
  bool? isLoading;
  List<Products>? productsList;
  bool? isError;
  String? errorMessage;

  ProductsController(
      {this.isLoading, this.errorMessage, this.isError, this.productsList});

  ProductsController copyWith(
      {bool? isLoading,
      List<Products>? productsList,
      bool? isError,
      String? errorMessage}) {
    return ProductsController(
      productsList: productsList ?? this.productsList,
      isError: isError ?? this.isError,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ProductsProvider extends StateNotifier<ProductsController> {
  final Ref ref;
  ProductsProvider(this.ref)
      : super(ProductsController(isLoading: false, isError: false));

  Future getProductsList() async {
    state = state.copyWith(isLoading: true);
    try {
      final productsList =
          await ref.read(productsRepoProvider).getProducts(null);
      state = state.copyWith(
          productsList: productsList, isError: false, errorMessage: '');
    } catch (e) {
      state = state.copyWith(isError: true, errorMessage: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final productsProvider =
    StateNotifierProvider<ProductsProvider, ProductsController>(
        (ref) => ProductsProvider(ref));

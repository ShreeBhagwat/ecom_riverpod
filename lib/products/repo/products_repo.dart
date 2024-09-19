import 'package:dio/dio.dart';
import 'package:ecom/networking/api_endpoints.dart';
import 'package:ecom/networking/dio_client.dart';
import 'package:ecom/products/models/products.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsRepo {
  final Ref ref;

  ProductsRepo({required this.ref});

  Future<List<Products>> getProducts(String? category) async {
    Response response;
    if (category == null) {
      response =
          await ref.read(dioProvider).get(ApiEndpoints.GetProductsEndPoint);
    } else {
      response = await ref
          .read(dioProvider)
          .get('${ApiEndpoints.GetProductsByCategoryEndPoint}/$category');
    }
    if (response.statusCode == 200) {
      List<Products> productsList = response.data['products']
          .map<Products>((product) => Products.fromJson(product))
          .toList();
      return productsList;
    } else {
      return Future.error('Failed to get Products');
    }
  }
}

final productsRepoProvider = Provider((ref) => ProductsRepo(ref: ref));

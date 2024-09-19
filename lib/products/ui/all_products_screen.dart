import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:ecom/categories/models/categories_model.dart';
import 'package:ecom/networking/api_endpoints.dart';
import 'package:ecom/networking/dio_client.dart';
import 'package:ecom/products/models/products.dart';
import 'package:ecom/products/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllProductsScreen extends ConsumerStatefulWidget {
  const AllProductsScreen({super.key});

  @override
  ConsumerState<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends ConsumerState<AllProductsScreen> {
  final _dioClient = DioClient();
  String? category;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      await ref.read(productsProvider.notifier).getProductsList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsNotifier = ref.watch(productsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: FutureBuilder(
                future: getCategoryList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final category = snapshot.data![index];

                        return InkWell(
                          onTap: () {
                            this.category = category.slug;
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 216, 215, 215),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(child: Text(category.name)),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Center(
                      child: Text('Unable to get categories '),
                    );
                  }
                }),
          ),
          !productsNotifier.isLoading!
              ? !productsNotifier.isError!
                  ? productsNotifier.productsList != null
                      ? Expanded(
                          child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemCount: productsNotifier.productsList!.length,
                            itemBuilder: (context, index) {
                              final Products product =
                                  productsNotifier.productsList![index];
                              return Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: product.images!.first!,
                                    width: 100,
                                    fit: BoxFit.fitWidth,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(),
                                  ),
                                  Column(
                                    children: [
                                      Text(product.title!),
                                      SizedBox(
                                          width: 200,
                                          child: Text(product.description!)),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Text('NO Products found'),
                        )
                  : Center(
                      child: Text(productsNotifier.errorMessage!),
                    )
              : CircularProgressIndicator()
        ],
      ),
    );
  }

  Future<List<CategoryModel>> getCategoryList() async {
    final response =
        await _dioClient.get(ApiEndpoints.GetAllCategoriesEndPoint);
    if (response.statusCode == 200) {
      final categoriesList = response.data
          .map<CategoryModel>((category) => CategoryModel.fromJson(category))
          .toList();
      return categoriesList;
    } else {
      return Future.error('Failed to get categories');
    }
  }
}

class CategoryModel {
  final String slug;
  final String name;
  final String url;

  CategoryModel({
    required this.slug,
    required this.name,
    required this.url,
  });

  // Create a fromJson factory function
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      slug: json['slug'],
      name: json['name'],
      url: json['url'],
    );
  }

  // create a copywith function
  CategoryModel copyWith({
    String? slug,
    String? name,
    String? url,
  }) {
    return CategoryModel(
      slug: slug ?? this.slug,
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }
}

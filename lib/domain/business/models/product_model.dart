class ProductsResume {
  final String productId;
  final String name;
  int quantity;
  double subtotal;

  ProductsResume({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.subtotal,
  });

  factory ProductsResume.fromJson(Map<String, dynamic> json) {
    return ProductsResume(
      productId: json['productId'],
      name: json['name'],
      quantity: json['quantity'],
      subtotal: json['subtotal'],
    );
  }
}

class ProductModel {
  final String id;
  final String name;
  final String? description;
  final String? image;
  final double price;
  final String categoryId;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    this.image,
    required this.price,
    required this.categoryId
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'] == '' ? null : json['description'],
      image: json['image'] == '' ? null : json['image'],
      price: json['price'],
      categoryId: json['categoryId']
    );
  }
}
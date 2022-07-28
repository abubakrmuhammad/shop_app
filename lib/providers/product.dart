import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Product.withDefualtProps({
    this.id = '',
    this.title = '',
    this.description = '',
    this.price = 0.0,
    this.imageUrl = '',
    this.isFavorite = false,
  });

  Product.fromExistingProduct(
    Product existingProduct, {
    String? id,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
    bool? isFavorite,
  })  : id = id ?? existingProduct.id,
        title = title ?? existingProduct.title,
        description = description ?? existingProduct.description,
        price = price ?? existingProduct.price,
        imageUrl = imageUrl ?? existingProduct.imageUrl,
        isFavorite = isFavorite ?? existingProduct.isFavorite;

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;

    notifyListeners();
  }
}

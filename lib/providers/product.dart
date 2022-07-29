import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const _baseUrl =
    'https://shop-app-flutterino-default-rtdb.europe-west1.firebasedatabase.app/products';

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

  static Map<String, dynamic> toMap(Product product) {
    return {
      'title': product.title,
      'price': product.price,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'isFavorite': product.isFavorite,
    };
  }

  Future<void> toggleFavoriteStatus(String? authToken) async {
    final oldStatus = isFavorite;

    isFavorite = !isFavorite;

    notifyListeners();

    final url = Uri.parse('$_baseUrl/$id.json?auth=$authToken');

    try {
      await http.patch(url, body: json.encode(toMap(this)));
    } catch (e) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}

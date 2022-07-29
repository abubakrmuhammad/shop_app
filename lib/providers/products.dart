import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _products = [];

  UnmodifiableListView<Product> get products => UnmodifiableListView(_products);

  UnmodifiableListView<Product> get favoriteProducts =>
      UnmodifiableListView(_products.where((p) => p.isFavorite));

  Product findById(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        'https://shop-app-flutterino-default-rtdb.europe-west1.firebasedatabase.app/products.json');

    try {
      final res = await http.get(url);
      final productsData = json.decode(res.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];

      productsData.forEach((productId, data) {
        final product = Product(
          id: productId,
          title: data['title'],
          description: data['description'],
          price: data['price'],
          imageUrl: data['imageUrl'],
        );

        loadedProducts.add(product);
      });

      _products = loadedProducts;

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        "https://shop-app-flutterino-default-rtdb.europe-west1.firebasedatabase.app/products.json");
    final productJson = json.encode({
      'title': product.title,
      'price': product.price,
      'description': product.description,
      'imageUrl': product.imageUrl,
    });

    try {
      final response = await http.post(url, body: productJson);
      final productId = json.decode(response.body)['name'];

      final productToAdd = Product.fromExistingProduct(product, id: productId);

      _products.add(productToAdd);

      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  void updateProduct(String productId, Product updatedProduct) {
    final index = _products.indexWhere((p) => p.id == productId);

    _products[index] = updatedProduct;

    notifyListeners();
  }

  void deleteProduct(String productId) {
    _products.removeWhere((p) => p.id == productId);

    notifyListeners();
  }
}

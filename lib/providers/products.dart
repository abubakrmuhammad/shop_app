import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

const _baseUrl =
    'https://shop-app-flutterino-default-rtdb.europe-west1.firebasedatabase.app/products';

class Products with ChangeNotifier {
  List<Product> _products = [];
  final String? _authToken;
  final String? _userId;

  Products()
      : _authToken = null,
        _userId = null;

  Products.update({
    required String? authToken,
    required String? userId,
    required List<Product> products,
  })  : _products = products,
        _authToken = authToken,
        _userId = userId;

  UnmodifiableListView<Product> get products => UnmodifiableListView(_products);

  UnmodifiableListView<Product> get favoriteProducts =>
      UnmodifiableListView(_products.where((p) => p.isFavorite));

  Product findById(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse('$_baseUrl.json?auth=$_authToken');

    try {
      final res = await http.get(url);
      final productsData = json.decode(res.body) as Map<String, dynamic>?;
      final List<Product> loadedProducts = [];

      final favoritesUrl = Uri.parse(
          "https://shop-app-flutterino-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$_userId.json?auth=$_authToken");

      final favoritesRes = await http.get(favoritesUrl);
      final favoritesData = json.decode(favoritesRes.body);

      if (productsData != null) {
        productsData.forEach((productId, data) {
          final product = Product(
            id: productId,
            title: data['title'],
            description: data['description'],
            price: data['price'],
            imageUrl: data['imageUrl'],
            isFavorite: favoritesData == null
                ? false
                : favoritesData[productId] ?? false,
          );

          loadedProducts.add(product);
        });
      }

      _products = loadedProducts;

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse('$_baseUrl.json?auth=$_authToken');
    final productJson = json.encode(Product.toMap(product));

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

  Future<void> updateProduct(String productId, Product updatedProduct) async {
    final index = _products.indexWhere((p) => p.id == productId);

    _products[index] = updatedProduct;

    final url = Uri.parse('$_baseUrl/$productId.json?auth=$_authToken');

    await http.patch(url, body: json.encode(Product.toMap(updatedProduct)));

    notifyListeners();
  }

  Future<void> deleteProduct(String productId) async {
    final url = Uri.parse('$_baseUrl/$productId.json?auth=$_authToken');

    try {
      await http.delete(url);
      _products.removeWhere((p) => p.id == productId);
    } catch (e) {
      rethrow;
    }

    notifyListeners();
  }
}

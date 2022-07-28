import 'dart:collection';

import 'package:flutter/material.dart';

import '../data.dart';
import 'product.dart';

class Products with ChangeNotifier {
  final List<Product> _products = dummyProducts;

  UnmodifiableListView<Product> get products => UnmodifiableListView(_products);

  UnmodifiableListView<Product> get favoriteProducts =>
      UnmodifiableListView(_products.where((p) => p.isFavorite));

  Product findById(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  void addProduct(Product product) {
    final productToAdd =
        Product.fromExistingProduct(product, id: DateTime.now().toString());

    _products.add(productToAdd);

    notifyListeners();
  }
}

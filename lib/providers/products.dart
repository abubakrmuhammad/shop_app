import 'dart:collection';

import 'package:flutter/material.dart';

import '../data.dart';
import 'product.dart';

class Products with ChangeNotifier {
  final List<Product> _products = dummyProducts;

  UnmodifiableListView<Product> get products => UnmodifiableListView(_products);

  Product findById(String id) {
    return _products.firstWhere((product) => product.id == id);
  }
}

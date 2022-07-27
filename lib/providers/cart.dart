import 'dart:collection';

import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  const CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
  });
}

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return UnmodifiableMapView(_items);
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;

    _items.forEach((key, value) {
      total += value.quantity * value.price;
    });

    return total;
  }

  void addItem({
    required String productId,
    required double price,
    required String title,
  }) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (value) => CartItem(
                id: value.id,
                title: value.title,
                price: value.price,
                quantity: value.quantity + 1,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                quantity: 1,
              ));
    }

    notifyListeners();
  }

  void removeItem(id) {
    _items.removeWhere(((key, value) => value.id == id));

    notifyListeners();
  }
}

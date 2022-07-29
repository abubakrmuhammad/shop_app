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

  static Map<String, dynamic> toMap(CartItem item) {
    return {
      'id': item.id,
      'title': item.title,
      'price': item.price,
      'quantity': item.quantity,
    };
  }

  static CartItem fromMap(map) {
    return CartItem(
      id: map['id'],
      title: map['title'],
      price: map['price'],
      quantity: map['quantity'],
    );
  }
}

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return UnmodifiableMapView(_items);
  }

  int get itemCount {
    return _items.length;
  }

  int get totalProductsAdded {
    int totalItems = 0;

    _items.forEach((key, value) {
      totalItems += value.quantity;
    });

    return totalItems;
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

  void removeItem(String id) {
    _items.removeWhere(((key, value) => value.id == id));

    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          title: existingItem.title,
          price: existingItem.price,
          quantity: existingItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }

    notifyListeners();
  }

  void clearCart() {
    _items.removeWhere((key, value) => true);

    notifyListeners();
  }
}

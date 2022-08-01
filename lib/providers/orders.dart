import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

const _baseUrl =
    'https://shop-app-flutterino-default-rtdb.europe-west1.firebasedatabase.app/orders';

class OrderItem {
  final String? id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  const OrderItem({
    this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });

  OrderItem.fromExistingOrder(
    OrderItem orderItem, {
    String? id,
    double? amount,
    List<CartItem>? products,
    DateTime? dateTime,
  })  : id = id ?? orderItem.id,
        amount = amount ?? orderItem.amount,
        products = products ?? orderItem.products,
        dateTime = dateTime ?? orderItem.dateTime;

  static Map<String, dynamic> toMap(OrderItem order) {
    return {
      'amount': order.amount,
      'dateTime': order.dateTime.toIso8601String(),
      'products': order.products.map(CartItem.toMap).toList(),
    };
  }

  static OrderItem fromMap(Map<String, dynamic> map) {
    final amount = map['amount'] as double;
    final dateTime = DateTime.parse(map['dateTime'] as String);
    final products = (map['products'] as List).map(CartItem.fromMap).toList();

    return OrderItem(amount: amount, products: products, dateTime: dateTime);
  }
}

// Order Map
// {
//   'amount': 59.98,
//   'dateTime': '2022-07-29T10:47:41.248062',
//   'products': [
//     {
//       'id': '2022-07-29 10:47:37.574228',
//       'price': 29.99,
//       'quantity': 2,
//       'title': 'Red Shirt'
//     }
//   ]
// }

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String? _authToken;
  final String? _userId;

  Orders()
      : _authToken = null,
        _userId = null;
  Orders.update(
      {required String? authToken,
      required String? userId,
      required List<OrderItem> orders})
      : _authToken = authToken,
        _userId = userId,
        _orders = orders;

  List<OrderItem> get orders {
    return UnmodifiableListView(_orders);
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse('$_baseUrl/$_userId.json?auth=$_authToken');
    final response = await http.get(url);

    final ordersData = json.decode(response.body) as Map<String, dynamic>?;

    final List<OrderItem> loadedOrders = [];

    if (ordersData == null) return;
    ordersData.forEach((orderId, data) {
      final order =
          OrderItem.fromExistingOrder(OrderItem.fromMap(data), id: orderId);

      loadedOrders.insert(0, order);
    });

    _orders = loadedOrders;

    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final order = OrderItem(
      amount: total,
      products: cartProducts,
      dateTime: DateTime.now(),
    );

    final url = Uri.parse('$_baseUrl/$_userId.json?auth=$_authToken');
    final orderJson = json.encode(OrderItem.toMap(order));

    final response = await http.post(url, body: orderJson);
    final orderId = json.decode(response.body)['name'];

    final orderToAdd = OrderItem.fromExistingOrder(order, id: orderId);

    _orders.insert(0, orderToAdd);

    notifyListeners();
  }
}

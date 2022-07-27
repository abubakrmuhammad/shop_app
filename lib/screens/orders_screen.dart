import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context, listen: false).orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, i) => _OrderItem(orders[i]),
        ),
      ),
    );
  }
}

class _OrderItem extends StatelessWidget {
  final OrderItem order;

  const _OrderItem(this.order, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('\$${order.amount}'),
        subtitle: Text(DateFormat('dd MM yyyy hh:mm').format(order.dateTime)),
        trailing: IconButton(
          icon: const Icon(Icons.expand_more),
          onPressed: () {},
        ),
      ),
    );
  }
}

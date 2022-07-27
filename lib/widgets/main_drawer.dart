import 'package:flutter/material.dart';

import 'package:shop_app/screens/orders_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: const Text('Hello there!'),
          automaticallyImplyLeading: false,
        ),
        ListTile(
          leading: const Icon(Icons.shopping_bag),
          title: const Text('Shop'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        ListTile(
          leading: const Icon(Icons.payment),
          title: const Text('Orders'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
          },
        ),
      ]),
    );
  }
}

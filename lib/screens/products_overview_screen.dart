import 'package:flutter/material.dart';

import '../data.dart';

import '../widgets/product_item.dart';

class ProductOverviewScreen extends StatelessWidget {
  static const routeName = '/products';

  final products = dummyProducts;

  ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, i) => ProductItem(products[i]),
      ),
    );
  }
}

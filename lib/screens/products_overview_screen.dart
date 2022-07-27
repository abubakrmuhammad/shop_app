import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';

enum _FilterOptions { favorites, all }

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '/products';

  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool showFavsOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        actions: [
          PopupMenuButton(
              onSelected: (_FilterOptions value) {
                setState(() {
                  showFavsOnly = value == _FilterOptions.favorites;
                });
              },
              itemBuilder: (ctx) => [
                    const PopupMenuItem(
                      value: _FilterOptions.favorites,
                      child: Text('Only Favorites'),
                    ),
                    const PopupMenuItem(
                      value: _FilterOptions.all,
                      child: Text('Show  All'),
                    ),
                  ])
        ],
      ),
      body: ProductsGrid(showFavsOnly),
    );
  }
}

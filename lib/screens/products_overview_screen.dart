import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/main_drawer.dart';

import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge.dart';
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
          Consumer<Cart>(
            builder: (context, value, child) => Badge(
              value: value.itemCount.toString(),
              color: Colors.deepOrange,
              child: child!,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
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
      drawer: const MainDrawer(),
      body: ProductsGrid(showFavsOnly),
    );
  }
}

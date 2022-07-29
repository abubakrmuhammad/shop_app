import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/cart.dart';

import '../screens/cart_screen.dart';

import '../widgets/main_drawer.dart';
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
  bool _showFavsOnly = false;
  bool _isLoading = false;

  @override
  void initState() {
    fetchProducts();
    super.initState();
  }

  void fetchProducts() async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        actions: [
          Consumer<Cart>(
            builder: (context, value, child) => Badge(
              value: value.totalProductsAdded.toString(),
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
                  _showFavsOnly = value == _FilterOptions.favorites;
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ProductsGrid(_showFavsOnly),
    );
  }
}

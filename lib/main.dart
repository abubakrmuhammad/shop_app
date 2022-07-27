import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/products.dart';
import './providers/cart.dart';

import './screens/product_details_screen.dart';
import './screens/products_overview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Products()),
        ChangeNotifierProvider(create: (context) => Cart()),
      ],
      child: MaterialApp(
        title: 'Shop App',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          fontFamily: 'Lato',
        ),
        home: const ProductOverviewScreen(),
        routes: {
          ProductOverviewScreen.routeName: (ctx) =>
              const ProductOverviewScreen(),
          ProductDetailsScreen.routeName: (ctx) => const ProductDetailsScreen(),
        },
      ),
    );
  }
}

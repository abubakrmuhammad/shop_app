import 'package:flutter/material.dart';
import 'package:shop_app/screens/product_details_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Lato',
      ),
      home: ProductOverviewScreen(),
      routes: {
        ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
        ProductDetailsScreen.routeName: (ctx) => const ProductDetailsScreen(),
      },
    );
  }
}

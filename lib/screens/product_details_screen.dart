import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product';

  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('hello'),
      ),
    );
  }
}

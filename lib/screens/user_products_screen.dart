import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/main_drawer.dart';

import '../providers/products.dart';
import '../providers/product.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context).products;

    Future<void> refetchProducts(BuildContext context) async {
      await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Products'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName);
                },
                icon: const Icon(Icons.add)),
          ],
        ),
        drawer: const MainDrawer(),
        body: RefreshIndicator(
          onRefresh: (() => refetchProducts(context)),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) =>
                  _UserProductItem(products[index]),
            ),
          ),
        ));
  }
}

class _UserProductItem extends StatelessWidget {
  final Product product;

  const _UserProductItem(this.product, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        title: Text(product.title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(product.imageUrl),
          radius: 40,
        ),
        trailing: SizedBox(
          width: 100,
          child: Row(children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName,
                    arguments: product.id);
              },
              icon: const Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(product.id);
                } catch (e) {
                  scaffoldMessenger.hideCurrentSnackBar();
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Something went wrong',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.delete),
              color: Colors.red,
            ),
          ]),
        ),
      ),
    );
  }
}

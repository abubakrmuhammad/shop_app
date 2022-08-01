import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';

import './screens/splash_screen.dart';
import './screens/orders_screen.dart';
import './screens/product_details_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/cart_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/user_products_screen.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products(),
          update: (context, auth, previousProducts) => Products.update(
            authToken: auth.token,
            userId: auth.userId,
            products: previousProducts?.products ?? [],
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders(),
          update: ((context, auth, previousOrders) => Orders.update(
              authToken: auth.token,
              userId: auth.userId,
              orders: previousOrders?.orders ?? [])),
        ),
        ChangeNotifierProvider(create: (context) => Cart()),
      ],
      child: Consumer<Auth>(
        builder: ((ctx, auth, _) => MaterialApp(
              title: 'Shop App',
              theme: ThemeData(
                primarySwatch: Colors.indigo,
                fontFamily: 'Lato',
              ),
              home: auth.isAuthenticated
                  ? const ProductOverviewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (context, authResult) =>
                          authResult.connectionState == ConnectionState.waiting
                              ? const SplashScreen()
                              : const AuthScreen(),
                    ),
              routes: {
                ProductOverviewScreen.routeName: (ctx) =>
                    const ProductOverviewScreen(),
                ProductDetailsScreen.routeName: (ctx) =>
                    const ProductDetailsScreen(),
                CartScreen.routeName: (ctx) => const CartScreen(),
                OrdersScreen.routeName: (ctx) => const OrdersScreen(),
                UserProductsScreen.routeName: (ctx) =>
                    const UserProductsScreen(),
                EditProductScreen.routeName: (ctx) => const EditProductScreen(),
              },
            )),
      ),
    );
  }
}

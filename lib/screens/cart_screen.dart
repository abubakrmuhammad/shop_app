import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(children: [
        Card(
          margin: const EdgeInsets.all(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 18),
                ),
                const Spacer(),
                Chip(
                  label: Text(
                    '\$${cart.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 4),
                _OrderNowButton(
                  cart: cart,
                  text: 'ORDER NOW',
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: ((context, index) => Column(
                    children: [
                      _CartItem(cart.items.values.toList()[index]),
                      const SizedBox(height: 8),
                    ],
                  )),
            ),
          ),
        )
      ]),
    );
  }
}

class _OrderNowButton extends StatefulWidget {
  const _OrderNowButton({
    Key? key,
    required this.cart,
    required this.text,
  }) : super(key: key);

  final Cart cart;
  final String text;

  @override
  State<_OrderNowButton> createState() => _OrderNowButtonState();
}

class _OrderNowButtonState extends State<_OrderNowButton> {
  bool _isLoading = false;

  Future<void> orderHandler(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<Orders>(context, listen: false).addOrder(
      widget.cart.items.values.toList(),
      widget.cart.totalAmount,
    );

    setState(() {
      _isLoading = false;
    });

    widget.cart.clearCart();
  }

  @override
  Widget build(BuildContext context) {
    final shouldDisable = widget.cart.totalAmount <= 0 || _isLoading;

    return TextButton(
      onPressed: shouldDisable ? null : () => orderHandler(context),
      child: _isLoading ? const CircularProgressIndicator() : Text(widget.text),
    );
  }
}

class _CartItem extends StatelessWidget {
  final CartItem cartItem;

  const _CartItem(this.cartItem, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final price = cartItem.price;
    final title = cartItem.title;
    final quantity = cartItem.quantity;

    return Dismissible(
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(cartItem.id);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('Are you sure?'),
                  content: const Text(
                      'Do you want to remove the item from the cart?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                      child: const Text(
                        'No',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                      child: const Text(
                        'Yes',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ));
      },
      background: Container(
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(3),
        ),
        padding: const EdgeInsets.all(10),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 28,
        ),
      ),
      child: Card(
        margin: EdgeInsets.zero,
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: FittedBox(child: Text('\$ ${price.toStringAsFixed(2)}')),
            ),
          ),
          title: Text(title),
          subtitle: Text('Total: \$${price * quantity}'),
          trailing: Text('$quantity x'),
        ),
      ),
    );
  }
}

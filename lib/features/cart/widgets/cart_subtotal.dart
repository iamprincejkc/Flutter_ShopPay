import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop_pay/providers/user_provider.dart';

class CartSubtotal extends StatelessWidget {
  const CartSubtotal({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    double sum = 0;
    user.cart
        .map((e) => sum += e['quantity'] * e['product']['price'].toDouble())
        .toList();
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          const Text(
            'Subtotal ',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            NumberFormat.simpleCurrency(name: 'PHP', decimalDigits: 2)
                .format(sum),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shop_pay/common/widgets/loader.dart';
import 'package:shop_pay/features/account/widgets/single_product.dart';
import 'package:shop_pay/features/admin/services/admin_services.dart';
import 'package:shop_pay/features/order_details/screens/order_details_screen.dart';
import 'package:shop_pay/models/order.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order>? orders;
  final AdminServices adminServices = AdminServices();
  @override
  void initState() {
    super.initState();
    fetchAllOrders();
  }

  fetchAllOrders() async {
    orders = await adminServices.fetchAllOrders(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Loader()
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: orders!.length,
            itemBuilder: (BuildContext context, int index) {
              final orderData = orders![index];
              return GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, OrderDetailsScreen.routeName,
                    arguments: orderData),
                child: SizedBox(
                  height: 140,
                  child: SingleProduct(
                    image: orderData.products[0].images[0],
                  ),
                ),
              );
            },
          );
  }
}

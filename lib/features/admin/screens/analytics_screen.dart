import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_pay/common/widgets/loader.dart';
import 'package:shop_pay/features/admin/models/sales.dart';
import 'package:shop_pay/features/admin/services/admin_services.dart';
import 'package:shop_pay/features/admin/widgets/category_products_charts.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminServices adminServices = AdminServices();
  int? totalSales;
  List<Sales>? sales;
  @override
  void initState() {
    super.initState();
    getEarnings();
  }

  getEarnings() async {
    var earningData = await adminServices.getEarnings(context);
    totalSales = earningData['totalEarnings'];
    sales = earningData['sales'];
    setState(() {});
  }

  Widget build(BuildContext context) {
    return sales == null || totalSales == null
        ? const Loader()
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  const Text(
                    'Total Order Insights',
                    style: TextStyle(
                      fontFamily: 'default',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: CategoryProductsChart(
                      salesList: sales!,
                    ),
                  ),
                  Text(
                    'Total Order Revenue: ${NumberFormat.simpleCurrency(name: 'PHP', decimalDigits: 2).format(totalSales)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

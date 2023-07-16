import 'package:flutter/material.dart';
import 'package:shop_pay/constants/global_variables.dart';
import 'package:shop_pay/features/account/widgets/below_app_bar.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration:
                const BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              alignment: Alignment.topLeft,
              child: Image.asset(
                'assets/images/amazon_in.png',
                width: 120,
                height: 45,
                color: Colors.black,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(children: const [
                Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: Icon(Icons.notifications_outlined),
                ),
                Icon(Icons.search),
              ]),
            ),
          ]),
        ),
      ),
      body: Column(
        children: const [
          BelowAppBar(),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

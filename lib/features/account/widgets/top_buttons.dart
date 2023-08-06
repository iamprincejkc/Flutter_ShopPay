import 'package:flutter/material.dart';
import 'package:shop_pay/features/account/services/account_services.dart';
import 'package:shop_pay/features/account/widgets/account_button.dart';

class TopButtons extends StatelessWidget {
  const TopButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final AccountServices accountServices = AccountServices();
    return Column(
      children: [
        Row(
          children: [
            AccountButton(text: 'Your Orders', onTap: (() {})),
            AccountButton(text: 'Turn Seller', onTap: (() {})),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            AccountButton(
                text: 'Logout', onTap: (() => accountServices.logOut(context))),
            AccountButton(text: 'Your Wish List', onTap: (() {})),
          ],
        ),
      ],
    );
  }
}

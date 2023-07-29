import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_pay/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:shop_pay/models/user.dart';

import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../providers/user_provider.dart';

class CartServices {
  void removeFromCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response response = await http.delete(
        Uri.parse('$uri/api/remove-from-cart/${product.id}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: (() {
            User user = userProvider.user
                .copyWith(cart: jsonDecode(response.body)['cart']);
            userProvider.setUserFromModel(user);
          }));
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:shop_pay/constants/error_handling.dart';
import 'package:shop_pay/constants/global_variables.dart';
import 'package:shop_pay/constants/utils.dart';

import '../../models/user.dart';
import 'package:http/http.dart' as http;

class AuthService {
  //Sign Up
  void signUpUser({
    required String email,
    required String password,
    required String name,
    required BuildContext context,
  }) async {
    try {
      User user = User(
        id: '',
        email: email,
        name: name,
        password: password,
        address: '',
        type: '',
        token: '',
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(
                context, 'Account created! Login with the same credentials!');
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}

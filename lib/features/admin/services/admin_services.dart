import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_pay/constants/error_handling.dart';
import 'package:shop_pay/constants/utils.dart';
import 'package:shop_pay/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:shop_pay/providers/user_provider.dart';

import '../../../constants/global_variables.dart';

class AdminServices {
  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<File> images,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final cloudinary = CloudinaryPublic('dfuz56uze', 'zbsxm1bc');
      List<String> imageUrls = [];
      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: name),
        );
        imageUrls.add(res.secureUrl);
      }

      Product product = Product(
        name: name,
        description: description,
        quantity: quantity,
        price: price,
        images: imageUrls,
        category: category,
      );

      http.Response response = await http.post(
        Uri.parse('$uri/admin/add-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: product.toJson(),
      );
      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: (() {
            showSnackBar(context, 'Product added successfully');
            Navigator.pop(context);
          }));
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
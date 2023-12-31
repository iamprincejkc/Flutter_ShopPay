import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
import 'package:shop_pay/constants/utils.dart';
import 'package:shop_pay/features/address/services/address_services.dart';

import 'package:shop_pay/providers/user_provider.dart';

import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_textfield.dart';
import '../../../constants/global_variables.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  final String totalAmount;
  const AddressScreen({
    Key? key,
    required this.totalAmount,
  }) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _baranggaytController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final _addressFormKey = GlobalKey<FormState>();
  final AddressServices addressServices = AddressServices();

  String addressToBeUsed = "";

  List<PaymentItem> _paymentItems = [];

  final Future<PaymentConfiguration> _googlePayConfigFuture =
      PaymentConfiguration.fromAsset('gpay.json');
  final Future<PaymentConfiguration> _applePayConfigFuture =
      PaymentConfiguration.fromAsset('applepay.json');

  @override
  void initState() {
    super.initState();
    _paymentItems.add(
      PaymentItem(
        amount: widget.totalAmount,
        label: 'Total Amount',
        status: PaymentItemStatus.final_price,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _addressController.dispose();
    _streetController.dispose();
    _baranggaytController.dispose();
    _cityController.dispose();
  }

  void onGooglePayResult(paymentResult) {
    if (Provider.of<UserProvider>(context, listen: false)
        .user
        .address
        .isNotEmpty) {
      addressServices.saveUserAddress(
          context: context, address: addressToBeUsed);
      addressServices.placeOrder(
        context: context,
        address: addressToBeUsed,
        totalSum: double.parse(widget.totalAmount),
      );
    }
  }

  void onApplePayResult(paymentResult) {
    if (Provider.of<UserProvider>(context, listen: false)
        .user
        .address
        .isEmpty) {
      addressServices.saveUserAddress(
          context: context, address: addressToBeUsed);
      addressServices.placeOrder(
        context: context,
        address: addressToBeUsed,
        totalSum: double.parse(widget.totalAmount),
      );
    }
  }

  void payPressed(String addressFromProvider) {
    addressToBeUsed = "";

    bool isForm = _addressController.text.isNotEmpty ||
        _streetController.text.isNotEmpty ||
        _baranggaytController.text.isNotEmpty ||
        _cityController.text.isNotEmpty;

    if (isForm) {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed =
            '${_addressController.text}, ${_streetController.text}, ${_baranggaytController.text}, ${_cityController.text}';
      } else {
        throw Exception("Please enter all values");
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressToBeUsed = addressFromProvider;
    } else {
      showSnackBar(context, "You dont have an address!");
    }
  }

  @override
  Widget build(BuildContext context) {
    var address = context.watch<UserProvider>().user.address;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration:
                const BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (address.isNotEmpty)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Text(address, style: const TextStyle(fontSize: 18)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('OR', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 20),
                  ],
                ),
              Form(
                key: _addressFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: _addressController,
                      hintText: 'Permanent Address',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _streetController,
                      hintText: 'Street',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _baranggaytController,
                      hintText: 'Baranggay',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _cityController,
                      hintText: 'Province/City',
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              FutureBuilder<PaymentConfiguration>(
                  future: _googlePayConfigFuture,
                  builder: (context, snapshot) => snapshot.hasData
                      ? GooglePayButton(
                          onPressed: () => payPressed(address),
                          width: double.infinity,
                          height: 50,
                          paymentConfiguration: snapshot.data!,
                          paymentItems: _paymentItems,
                          type: GooglePayButtonType.checkout,
                          margin: const EdgeInsets.only(top: 15.0),
                          onPaymentResult: onGooglePayResult,
                          loadingIndicator: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : const SizedBox.shrink()),
              const SizedBox(height: 10),
              FutureBuilder<PaymentConfiguration>(
                  future: _googlePayConfigFuture,
                  builder: (context, snapshot) => snapshot.hasData
                      ? ApplePayButton(
                          onPressed: () => payPressed(address),
                          width: double.infinity,
                          height: 50,
                          paymentConfiguration: snapshot.data!,
                          paymentItems: _paymentItems,
                          style: ApplePayButtonStyle.whiteOutline,
                          type: ApplePayButtonType.checkout,
                          margin: const EdgeInsets.only(top: 15.0),
                          onPaymentResult: onApplePayResult,
                          loadingIndicator: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}

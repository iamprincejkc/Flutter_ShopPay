import 'package:flutter/material.dart';
import 'package:shop_pay/common/widgets/custom_button.dart';
import 'package:shop_pay/common/widgets/custom_textfield.dart';
import 'package:shop_pay/constants/global_variables.dart';
import 'package:shop_pay/features/services/auth_service.dart';

enum Auth { signin, signup }

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth.signup;
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
  }

  void signUpUser() {
    authService.signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      name: _fullNameController.text,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundCOlor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: const Text(
                  'Create Account',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: Radio(
                  value: Auth.signup,
                  groupValue: _auth,
                  activeColor: GlobalVariables.secondaryColor,
                  onChanged: ((Auth? value) {
                    setState(() {
                      _auth = value!;
                    });
                  }),
                ),
              ),
              if (_auth == Auth.signup)
                Form(
                  key: _signUpFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        controller: _emailController,
                        hintText: 'Email',
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _fullNameController,
                        hintText: 'Full Name',
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                        text: 'Sign Up',
                        onTap: () {
                          if (_signUpFormKey.currentState!.validate()) {
                            signUpUser();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ListTile(
                title: const Text(
                  'Sign In',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: Radio(
                  value: Auth.signin,
                  groupValue: _auth,
                  activeColor: GlobalVariables.secondaryColor,
                  onChanged: ((Auth? value) {
                    setState(() {
                      _auth = value!;
                    });
                  }),
                ),
              ),
              if (_auth == Auth.signin)
                Form(
                  key: _signUpFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        controller: _emailController,
                        hintText: 'Email',
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _fullNameController,
                        hintText: 'Full Name',
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                      ),
                      const SizedBox(height: 10),
                      CustomButton(text: 'Sign In', onTap: (() {}))
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

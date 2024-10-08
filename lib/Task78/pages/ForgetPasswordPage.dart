import 'package:flutter/material.dart';
import 'package:get/utils.dart';

import '../commonWidgets/custom_button.dart';
import '../commonWidgets/custom_text.dart';
import '../commonWidgets/custom_textfield.dart';
import '../controllers/authController.dart';

class ForgetPasswordPage extends StatefulWidget{
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController _emailTextEditingController = TextEditingController();
  final AuthController _authController = AuthController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text("Forget Password"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 150,),
            SizedBox(
              height: 350,
              width: 350,
              child: Image.asset('assets/forgetPassword.png'),
            ),
            const SizedBox(height: 20,),
            CustomText("Don't worry, everyone forgets sometimes", 16, alignment: Alignment.center),
            CustomText("We've got you covered", 16, alignment: Alignment.center),
            const SizedBox(height: 40,),
            CustomText("Enter your Email", 20, alignment: Alignment.center, bold: true,),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: CustomTextfield(
                  const Icon(Icons.email_outlined, color: Colors.black,),
                  "john@gmail.com",
                  false,
                  _emailTextEditingController,
                  validationCallback: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an Email!';
                    }
                    if (!value.isEmail) {
                      return 'Please enter a valid Email!';
                    }
                    return null;
                  },
                  key: const Key("emailTextField"),
                ),
              ),
            ),
            CustomButton("Reset Password", () async {
              if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                // print("Password: ${_passwordEditingController.text.trim()}");
                _authController.resetPassword(_emailTextEditingController.text.trim());
              }
            })
          ],
        ),
      ),
    );
  }
}
import 'package:aicp_internship/Task4/pages/SignUpPage.dart';
import 'package:aicp_internship/Task4/controllers/authController.dart';
import 'package:aicp_internship/Task4/commonWidgets/custom_text.dart';
import 'package:aicp_internship/Task4/commonWidgets/sign_in_providers.dart';
import 'package:aicp_internship/Task4/pages/userPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../utils/rememberMeCheckBox.dart';
import 'ForgetPasswordPage.dart';
import '../commonWidgets/custom_button.dart';
import '../commonWidgets/custom_textfield.dart';

class SignInPage extends StatefulWidget{
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with TickerProviderStateMixin{
  late AnimationController _firstController;
  late AnimationController _secondController;
  late Animation<double> _firstWidthAnimation;
  late Animation<double> _firstHeightAnimation;
  late Animation<double> _secondWidthAnimation;
  late Animation<double> _secondHeightAnimation;

  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();
  final AuthController _authController = AuthController();
  late String _errorText = "";

  final _formKey = GlobalKey<FormState>();

  late String _email, _password;
  void openSignUp(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpPage()));
  }

  @override
  void initState() {
    super.initState();
    _firstController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _secondController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _firstWidthAnimation = Tween<double>(begin: 0, end: 400).animate(_firstController);
    _firstHeightAnimation = Tween<double>(begin: 0, end: 400).animate(_firstController);

    _secondWidthAnimation = Tween<double>(begin: 0, end: 400).animate(_secondController);
    _secondHeightAnimation = Tween<double>(begin: 0, end: 400).animate(_secondController);

    _firstController.forward();

    Future.delayed(const Duration(milliseconds: 100), () {
      _secondController.forward();
    });

    var (email, password) = _authController.getRememberMeDetails();
    _email = email;
    _password = password;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    var (email, password) = _authController.getRememberMeDetails();
    _email = email;
    _password = password;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.black.withOpacity(0.00002),
          ),
          toolbarHeight: 50,
          title: Row(
            children: [
              const SizedBox(width: 30,),
              Container(
                margin: EdgeInsets.only(top: 25),
                child: const Text("Log In", style: TextStyle(
                  fontSize: 25,
                )),
              )
            ],
          ),
        ),
      body: Stack(
        children: [
          Positioned(
            top: -150,
            left: -250,
            child: AnimatedBuilder(
              animation: _firstController,
              builder: (context, child) {
                return Container(
                  width: _firstWidthAnimation.value,
                  height: _firstHeightAnimation.value,
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(400),
                      color: Colors.blueGrey[100]
                      // color: HexColor.fromHexStr(AppColor.primaryThemeSwatch3).withOpacity(0.3)
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 650,
            right: -230,
            child: AnimatedBuilder(
                animation: _firstController,
                builder: (context, child){
                  return Container(
                    width: _firstWidthAnimation.value,
                    height: _firstHeightAnimation.value,
                    padding: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(400),
                        color: Colors.blueGrey[100]
                    ),
                  );
                }
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 100,),
                      CustomText("Username Or Email",20, bold: true,),
                      CustomTextfield(
                        const Icon(Icons.email_outlined, color: Colors.black,),
                        "john@gmail.com",
                        value: _email,
                        false,
                        _emailEditingController,
                        validationCallback: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email!';
                          }
                          if(!value.isEmail){
                            return 'Please enter a valid email!';
                          }
                          return null;
                        },
                        key: const Key("emailTextField"),
                      ),
                      Container(
                        height: 20,
                      ),
                      CustomText("Enter Password",20, bold: true,),
                      CustomTextfield(
                        const Icon(Icons.lock_outline, color: Colors.black,),
                        "**********",
                        true,
                        _passwordEditingController,
                        value: _password,
                        validationCallback: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password!';
                          }
                          return null;
                        },
                        key: const Key("passwordTextField"),
                      ),
                      Row(
                        children: [
                          RememberMe(authController: _authController),
                          Spacer(),
                          CustomText(
                            "Forget Password",
                            16,
                            bold: true,
                            underline: true,
                            color: Colors.white,
                            alignment: Alignment.center,
                            onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgetPasswordPage()));},
                          ),
                        ],
                      ),
                      _errorText.isNotEmpty ?  Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(left: 20),
                        // color: Colors.blue,
                        child: Text(getErrorText(_errorText), style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                        ),textAlign: TextAlign.start,),
                      ) : Container(),
                      CustomButton("LOGIN", () async {
                        if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                          setState(() {
                            _errorText = "";
                          });
                          print("Password: ${_passwordEditingController.text.trim()}");
                          try {
                            var loginResult = await _authController.login(
                              _emailEditingController.text.trim(),
                              _passwordEditingController.text.trim(),
                            );

                            if (loginResult) {
                              print("Login successful ${loginResult.runtimeType}");
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserPage()));

                            } else {
                              print("Login failed");
                            }
                          } catch (e) {
                            print("Error: ${e.toString()}");
                            setState(() {
                              _errorText = e.toString();
                            });
                          }
                        }
                      }),
                      SignInProviders(),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText("Don't have an Account?", 18, bold: true),
                          Container(width: 10,),
                          CustomText(
                            "Sign Up",
                            18,
                            bold: true,
                            underline: true,
                            color: Colors.white,
                            onTap: openSignUp,
                          ),
                        ],
                      ),
                      const SizedBox(height: 40,),
                    ],
                  ),
                ),
              ),
            )
          ),
        ],
      )
    );
  }

  String getErrorText(String e){
    if(e.contains("invalid-credential")){
      return "Invalid Email or Password";
    }
    else if(e.contains("network-request-failed")){
      return "No Internet Connection";
    }
    return "Some Error Occurred";
  }
}

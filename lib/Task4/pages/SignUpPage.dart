import 'package:aicp_internship/Task4/pages/SignInPage.dart';
import 'package:aicp_internship/Task4/controllers/authController.dart';
import 'package:aicp_internship/Task4/commonWidgets/custom_button.dart';
import 'package:aicp_internship/Task4/commonWidgets/custom_text.dart';
import 'package:aicp_internship/Task4/commonWidgets/custom_textfield.dart';
import 'package:aicp_internship/Task4/controllers/redirectionController.dart';
import 'package:aicp_internship/Task4/commonWidgets/sign_in_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../utils/termsAndConditionsCheckBox.dart';

class SignUpPage extends StatefulWidget{

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin{
  late AnimationController _firstController;
  late AnimationController _secondController;
  late Animation<double> _firstWidthAnimation;
  late Animation<double> _firstHeightAnimation;
  late Animation<double> _secondWidthAnimation;
  late Animation<double> _secondHeightAnimation;

  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _usernameEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();
  final TextEditingController _confirmPasswordEditingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final AuthController authController = AuthController();

  bool isTermsAccepted = false;
  late String _errorText = "";

  void openSignIn(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignInPage()));
  }

  @override
  void initState() {
    super.initState();
    _firstController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _secondController = AnimationController(
      duration: Duration(milliseconds: 1000),
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
  }

  String _getErrorText(String e){
    if(e.contains("email-already-in-use")){
      return "Email Already in Use";
    }
    else if(e.contains("network-request-failed")){
      return "No Internet Connection";
    }
    return "Some Error Occurred";
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter Password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
      return 'Password must contain a one letter';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain a special character';
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
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
                    child: const Text("Sign Up", style: TextStyle(
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
            right: -250,
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
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 730,
            left: -100,
            child: AnimatedBuilder(
                animation: _secondController,
                builder: (context, child){
                  return Container(
                    width: _secondWidthAnimation.value,
                    height: _secondHeightAnimation.value,
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
            decoration: BoxDecoration(
              // color: HexColor.fromHexStr(AppColor.primaryThemeSwatch1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 100,),
                      // const PrimaryLogo(),
                      Container(
                        height: 20,
                      ),
                      CustomText("Email or Phone",20, bold: true,),
                      CustomTextfield(
                          const Icon(Icons.email_outlined, color: Colors.black,),
                          "john@gmail.com",
                          false,
                          isEmail: true,
                          _emailEditingController,
                          validationCallback: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Email OR Contact';
                            }
                            if(!value.isEmail){
                              return 'Please enter a valid Email!';
                            }

                            return null;
                          },
                          key: const Key("emailTextField")
                      ),
                      Container(
                        height: 20,
                      ),
                      CustomText("Username",20, bold: true,),
                      CustomTextfield(
                        const Icon(Icons.person_outline, color: Colors.black,),
                        "john123",
                        false,
                        _usernameEditingController,
                          validationCallback: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Username';
                            }

                            return null;
                          },
                          key: const Key("userNameTextField")
                      ),
                      Container(
                        height: 20,
                      ),
                      CustomText("Password",20, bold: true,),
                      CustomTextfield(
                        const Icon(Icons.lock_outline, color: Colors.black,),
                        "**********",
                        true,
                        _passwordEditingController,
                          validationCallback: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Password';
                            }
                            if(_passwordEditingController.text.trim().isNotEmpty){
                              return _validatePassword(_passwordEditingController.text.trim())?.toUpperCase();
                            }
                            return null;
                          },
                          key: const Key("passwordTextField")
                      ),
                      Container(
                        height: 20,
                      ),
                      CustomText("Confirm Password",20, bold: true,),
                      CustomTextfield(
                        const Icon(Icons.lock_outline, color: Colors.black,),
                        "**********",
                        true,
                        _confirmPasswordEditingController,
                          validationCallback: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Confirm Password';
                            }
                            if(value.trim() != _passwordEditingController.text.trim()){
                              return 'Passwords Do Not Match'.toUpperCase();
                            }
                            return null;
                          },
                          key: const Key("confirmPasswordTextField")
                      ),
                      TermsAndConditions(
                        onChanged: (value) {
                          setState(() {
                            isTermsAccepted = value;
                          });
                        }
                      ),
                      _errorText.isNotEmpty ?  Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(left: 20),
                        // color: Colors.blue,
                        child: Text(_getErrorText(_errorText), style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                        ),textAlign: TextAlign.start,),
                      ) : Container(),
                      Container(
                        height: 20,
                      ),
                      CustomButton(
                        "SIGN UP",
                        () async {
                          setState(() {
                            _errorText = "";
                          });
                          if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                            try {
                              var signUpResult = await authController.createAccount(
                                _emailEditingController.text.trim(),
                                _usernameEditingController.text.trim(),
                                _passwordEditingController.text.trim(),
                              );

                              if (signUpResult) {
                                print("Sign Up Done ${signUpResult.runtimeType}");
                                List<String> params = [_emailEditingController.text.trim()];

                                await RedirectionController.redirectToPage(10, (route) async {
                                  await Navigator.push(context, route);
                                }, params);

                              }
                            } catch (e) {
                              print("Here");
                              print("Error: ${e.toString()}");
                              setState(() {
                                _errorText = e.toString();
                              });
                            }
                          }
                        },
                        isEnabled: isTermsAccepted,
                      ),
                      SignInProviders(),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText("Already have an account?", 18, bold: true),
                          Container(width: 10,),
                          CustomText(
                            "Log In",
                            18,
                            bold: true,
                            underline: true,
                            color: Colors.white,
                            onTap: openSignIn,
                          ),
                        ],
                      ),
                      SizedBox(height: 40,),
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
}
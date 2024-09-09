import 'package:aicp_internship/Task78/pages/SignInPage.dart';
import 'package:aicp_internship/Task78/controllers/authController.dart';
import 'package:aicp_internship/Task78/commonWidgets/custom_button.dart';
import 'package:aicp_internship/Task78/commonWidgets/custom_text.dart';
import 'package:aicp_internship/Task78/commonWidgets/custom_textfield.dart';
import 'package:aicp_internship/Task78/controllers/redirectionController.dart';
import 'package:aicp_internship/Task78/commonWidgets/sign_in_providers.dart';
import 'package:aicp_internship/Task78/utils/profilePhoto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

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
  final TextEditingController _cityEditingController = TextEditingController();
  final TextEditingController _addressEditingController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  String _userType = 'User';
  String _phoneNumber = "";
  String _phoneCountryCode = "";
  String _phoneCountryISOCode = "";

  final _formKey = GlobalKey<FormState>();
  final AuthController authController = AuthController();
  XFile? _profileImage;

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

  void onTap() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxHeight: 512,
      maxWidth: 512,
    );
    if (image != null) {
      setState(() {
        _profileImage = image;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.blue[100],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.black.withOpacity(0.00002),
          ),
          toolbarHeight: 60,
          title: Row(
            children: [
              const SizedBox(width: 30,),
              Container(
                margin: EdgeInsets.only(top: 25),
                    child: const Text("Sign Up", style: TextStyle(
                      fontFamily: 'Modernist',
                      fontWeight: FontWeight.w700,
                      color: Colors.blue,
                      fontSize: 25
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
                      color: Colors.blue[200]
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
                        color: Colors.blue[200]
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 100,),
                      // const PrimaryLogo(),
                      ProfilePhoto(onTap:onTap, size: 140, profileImage: _profileImage,),
                      Container(
                        height: 20,
                      ),
                      CustomText("Email",20, bold: true,),
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
                      CustomText("Phone Number",20, bold: true,),
                      IntlPhoneField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 3.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.blueAccent,
                              width: 3.0,
                            ),
                          ),
                        ),
                        initialCountryCode: 'PK',
                        onChanged: (phone) {
                          print(phone.completeNumber);
                          _phoneNumberController.text = phone.completeNumber;
                          _phoneNumber = phone.number;
                          _phoneCountryCode = phone.countryCode;
                          _phoneCountryISOCode = phone.countryISOCode;
                        },
                        onCountryChanged: (country) {
                        },
                        validator: (value) {
                          if (value == null || value.number == "") {
                            return 'Please Enter a Phone number';
                          } else if (value.number.length < 10) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                        key: const Key("phoneNumberTextField"),
                      ),

                      CustomTextfield(
                          const Icon(Icons.drive_file_rename_outline, color: Colors.blue,),
                          "First Name",
                          false,
                          isEmail: false,
                          _firstNameController,
                          validationCallback: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter First Name';
                            }
                            return null;
                          },
                          key: const Key("firstNameTextField")
                      ),
                      SizedBox(height: 26),
                      CustomTextfield(
                          const Icon(Icons.drive_file_rename_outline, color: Colors.blue,),
                          "Middle name",
                          false,
                          isEmail: false,
                          _middleNameController,
                          key: const Key("middleNameTextField")
                      ),
                      SizedBox(height: 26),
                      CustomTextfield(
                          const Icon(Icons.drive_file_rename_outline, color: Colors.blue,),
                          "Last Name",
                          false,
                          isEmail: false,
                          _lastNameController,
                          key: const Key("lastNameTextField")
                      ),
                      SizedBox(height: 26),

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
                      Container(
                        height: 20,
                      ),
                      CustomText("City",20, bold: true,),
                      CustomTextfield(
                          const Icon(Icons.location_city, color: Colors.black,),
                          "Rawalpindi",
                          false,
                          _cityEditingController,
                          validationCallback: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter City';
                            }
                            return null;
                          },
                          key: const Key("cityTextField")
                      ),
                      Container(
                        height: 20,
                      ),

                      CustomText("Address",20, bold: true,),
                      CustomTextfield(
                          const Icon(Icons.location_on, color: Colors.black,),
                          "House Number, City, State",
                          false,
                          _addressEditingController,
                          validationCallback: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Address';
                            }
                            return null;
                          },
                          key: const Key("addressTextField")
                      ),
                      SizedBox(height: 16),
                      Text('User Type:'),
                      ListTile(
                        title: const Text('User'),
                        leading: Radio<String>(
                          value: 'User',
                          groupValue: _userType,
                          onChanged: (value) {
                            setState(() {
                              _userType = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Business Admin'),
                        leading: Radio<String>(
                          value: 'Business Admin',
                          groupValue: _userType,
                          onChanged: (value) {
                            setState(() {
                              _userType = value!;
                            });
                          },
                        ),
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
                            if (_phoneNumber.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Phone number cannot be empty')),
                              );
                              return;
                            }

                            try {
                              Map<String, String> phone = {
                                "phoneNumber": _phoneNumber.removeAllWhitespace,
                                "countryCode": _phoneCountryCode.removeAllWhitespace,
                                "countryISOCode": _phoneCountryISOCode.removeAllWhitespace,
                                "completePhoneNumber": _phoneNumberController.text.removeAllWhitespace,
                              };
                              Map<String, String> name = {
                                "firstName": _firstNameController.text,
                                "middleName": _middleNameController.text,
                                "lastName": _lastNameController.text,
                              };

                              var signUpResult = await authController.createAccount(
                                _emailEditingController.text.trim(),
                                _usernameEditingController.text.trim(),
                                _passwordEditingController.text.trim(),
                                _cityEditingController.text.trim(),
                                _addressEditingController.text.trim(),
                                _userType,
                                _profileImage!,
                                phone,
                                name
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
                            color: Colors.blue,
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
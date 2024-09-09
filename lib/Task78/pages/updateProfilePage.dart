import 'dart:io';
import 'package:aicp_internship/Task78/commonWidgets/custom_textfield.dart';
import 'package:aicp_internship/Task78/controllers/authController.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../models/user.dart';
import '../utils/profilePhoto.dart';

class UpdateProfilePage extends StatefulWidget {
  final AppUser user;

  UpdateProfilePage({required this.user});

  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  String _userType = 'U';
  XFile? _selectedImage;
  String? _profileImageUrl;

  String _phoneNumber = "";
  String _phoneCountryCode = "";
  String _phoneCountryISOCode = "";

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.user.userName ?? '';
    _emailController.text = widget.user.email ?? '';
    _cityController.text = widget.user.city ?? '';
    _addressController.text = widget.user.address ?? '';
    _userType = widget.user.type ?? 'U';
    _profileImageUrl = widget.user.profilePicUrl;
    _phoneNumberController.text = widget.user.phone?["completePhoneNumber"] ?? '';

    print(widget.user.phone);

    _phoneNumber = widget.user.phone?["phoneNumber"];
    _phoneCountryCode = widget.user.phone?["countryCode"];
    _phoneCountryISOCode = widget.user.phone?["countryISOCode"];
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      if (_phoneNumber.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Phone number cannot be empty')),
        );
        return;
      }

      AuthController authController = AuthController();
      try {
        String? downloadUrl = _profileImageUrl;

        if (_selectedImage != null) {
          downloadUrl = await authController.uploadProfilePic(downloadUrl!, widget.user.uid ?? "", _selectedImage!.path);
        }

        Map<String, String> phoneDetails = {
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

        await authController.updateProfile(
          uid: widget.user.uid ?? "",
          userName: _usernameController.text,
          email: _emailController.text,
          city: _cityController.text,
          address: _addressController.text,
          phone: phoneDetails,
          profileImageUrl: downloadUrl,
          name: name
        );

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Profile updated successfully!')),
        // );
      } catch (e) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Error updating profile: $e')),
        // );
      }
    }
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
        _selectedImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Text('Update Profile', style: TextStyle(
          fontFamily: 'Modernist',
          fontWeight: FontWeight.w700,
          color: Colors.blue
        )),
        backgroundColor: Colors.blue[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                ProfilePhoto(onTap:onTap, size: 170, profileImage: _selectedImage, profileImageUrl: widget.user.profilePicUrl ?? "",),
                SizedBox(height: 10),
                Text("Click to Update Image", style: TextStyle(
                  fontFamily: 'Lilac',
                )),
                SizedBox(height: 16),
                CustomTextfield(
                  const Icon(Icons.person, color: Colors.blue,),
                  "",
                  false,
                  isEmail: false,
                  _usernameController,
                  validationCallback: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Username';
                    }
                    return null;
                  },
                  key: const Key("userNameTextField")
                ),
                SizedBox(height: 26),
                IntlPhoneField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.blue[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 3.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(
                        color: Colors.blueAccent,
                        width: 3.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide.none,
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  initialCountryCode: _phoneCountryISOCode,
                  initialValue: _phoneNumber,
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

                SizedBox(height: 16),
                CustomTextfield(
                  const Icon(Icons.email, color: Colors.blue,),
                  "john@gmail.com",
                  false,
                  isEmail: true,
                  _emailController,
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
                SizedBox(height: 16),
                CustomTextfield(
                  const Icon(Icons.location_city, color: Colors.blue,),
                  "Rawalpindi",
                  false,
                  _cityController,
                  validationCallback: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter City';
                    }
                    return null;
                  },
                  key: const Key("cityTextField")
                ),
                SizedBox(height: 16),
                CustomTextfield(
                    const Icon(Icons.location_on, color: Colors.blue,),
                    "House Number, City, State",
                    false,
                    _addressController,
                    validationCallback: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Address';
                      }
                      return null;
                    },
                    key: const Key("addressTextField")
                ),

                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _updateProfile,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue[400]!),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    side: MaterialStateProperty.all<BorderSide>(BorderSide.none),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                    ),
                  ),
                  child: Text('UPDATE PROFILE'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

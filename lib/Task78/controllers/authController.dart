import 'package:aicp_internship/Task78/pages/SignInPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

import '../models/user.dart';

class AuthController extends GetxController {
  var isSignedIn = false.obs;
  var rememberMe = false;
  var localStorage = GetStorage();
  late String email;
  late String password;

  @override
  void onInit() {
    super.onInit();
    _checkAuthState();
  }

  Future<AppUser?> login(String email, String password, {bool rememberMe = false}) async {
    if (rememberMe) {
      localStorage.write("REMEMBER_ME_EMAIL_OR_CONTACT", email);
      localStorage.write("REMEMBER_ME_PASSWORD", password);
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();

        if (userDoc.exists) {
          AppUser appUser = AppUser.fromDocument(userDoc);
          return appUser;
        } else {
          throw ("User document not found in Firestore.");
        }
      } else {
        throw ("Error logging in user.");
      }
    } on FirebaseAuthException catch (e) {
      throw ("Firebase Authentication Error: ${e.code}");
    } catch (e) {
      throw ("Unexpected Error: $e");
    }
  }

  Future<bool> createAccount(
      String email,
      String username,
      String password,
      String city,
      String address,
      String userType,
      XFile profileImage,
      Map<String, String> phone,
      Map<String, String> name
      ) async {

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;

      if (user != null) {
        String fileName = 'profile_${user.uid}.jpg';
        Reference storageRef =
        FirebaseStorage.instance.ref().child('profile_images/$fileName');

        UploadTask uploadTask = storageRef.putFile(File(profileImage.path));
        TaskSnapshot snapshot = await uploadTask;

        String downloadUrl = await snapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': email,
          'username': username,
          'city': city,
          'address': address,
          'userType': userType.toLowerCase() == 'business admin' ? "B" : "U",
          'profileImageUrl': downloadUrl,
          'createdAt': FieldValue.serverTimestamp(),
          'phone': {
            'phoneNumber': phone['phoneNumber'],
            'countryCode': phone['countryCode'],
            'countryISOCode': phone['countryISOCode'],
            'completePhoneNumber': phone['completePhoneNumber']
          },
          'name':{
            "firstName": name['firstName'],
            "middleName": name['middleName'],
            "lastName": name['lastName'],
          }
        });

        Get.snackbar('Success', 'User details added successfully!',
          snackPosition: SnackPosition.BOTTOM, );

        return true;
      } else {
        Get.snackbar('Error', 'Error Occurred!',
          snackPosition: SnackPosition.BOTTOM, );
        return false;
      }
    } on FirebaseAuthException catch (e) {
      throw ("Firebase Authentication Error: ${e.code}");
    } catch (e) {
      throw ("Unexpected Error: $e");
    }
  }

  void _checkAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        var isSignedIn;
        isSignedIn.value = false;
      } else {
        isSignedIn.value = true;
      }
    });
  }

  Future<bool> updateProfile(
      {required String uid,
      required String userName,
      required String email,
      required String city,
      required String address,
      required String? profileImageUrl,
      required Map<String, String> phone,
      required Map<String, String> name,}) async{
    try{
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({
        'username': userName,
        'email': email,
        'city': city,
        'address': address,
        'phone': {
          'phoneNumber': phone['phoneNumber'],
          'countryCode': phone['countryCode'],
          'countryISOCode': phone['countryISOCode'],
          'completePhoneNumber': phone['completePhoneNumber']
        },
        'profileImageUrl': profileImageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
        'name':{
          "firstName": name['firstName'],
          "middleName": name['middleName'],
          "lastName": name['lastName'],
        }
      });

      Get.snackbar('Success', 'User Updated Successfully!',
        snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.lightGreenAccent[100],
          colorText: Colors.black,
          icon: const Icon(Icons.check,),
      );

      return true;
    } catch(e){
      Get.snackbar('Failure', 'Error Occurred!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent[100],
        colorText: Colors.black,
        icon: const Icon(Icons.error,),
      );
      return false;
    }
  }

  Future<String> uploadProfilePic(String profileImageUrl, String uid, String selectedImagePath) async{
    String? downloadUrl = profileImageUrl;

    String fileName = 'profile_$uid.jpg';
    Reference storageRef =
    FirebaseStorage.instance.ref().child('profile_images/$fileName');
    UploadTask uploadTask = storageRef.putFile(File(selectedImagePath));
    TaskSnapshot snapshot = await uploadTask;
    downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  Future<AppUser?> getUserDetails() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      print("id: ${user?.uid}");

      if (user != null) {
        DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          return AppUser.fromDocument(userDoc);
        } else {
          print("User document does not exist.");
          return null;
        }
      } else {
        print("No user is currently signed in.");
        return null;
      }
    } catch (e) {
      print("Error fetching user details: $e");
      return null;
    }
  }

  Future<AppUser?> getUserDetailsById(String uid) async {
    try {

      if (uid != null) {
        DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (userDoc.exists) {
          return AppUser.fromDocument(userDoc);
        } else {
          print("User document does not exist.");
          return null;
        }
      } else {
        print("No user is currently signed in.");
        return null;
      }
    } catch (e) {
      print("Error fetching user details: $e");
      return null;
    }
  }

  Future resetPassword(String email) async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e){
      print(e);
    }
  }

  Future<List<AppUser>> getAllBusinessOwners() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userType', isEqualTo: 'B')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.map((doc) {
          return AppUser.fromDocument(doc);
        }).toList();
      } else {
        print("No business owners found.");
        return [];
      }
    } catch (e) {
      print("Error fetching business owners: $e");
      return [];
    }
  }


  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => SignInPage());
      Get.snackbar('Success', 'User Logged Out Successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.lightGreenAccent[100],
        colorText: Colors.black,
        icon: const Icon(Icons.check,),
      );
    } catch (e) {
      print('Error signing out: $e');
      Get.snackbar('Error', 'Some Error Occurred!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.lightGreenAccent[100],
        colorText: Colors.black,
        icon: const Icon(Icons.error,),
      );
    }
  }

  (String, String) getRememberMeDetails(){
    email = localStorage.read("REMEMBER_ME_EMAIL_OR_CONTACT") ?? "";
    password = localStorage.read("REMEMBER_ME_PASSWORD") ?? "";
    return (email, password);
  }

}
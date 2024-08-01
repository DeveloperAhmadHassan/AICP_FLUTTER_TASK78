import 'package:aicp_internship/Task4/pages/SignInPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:http/http.dart' as http;

class AuthController{
  var rememberMe = false;
  var localStorage = GetStorage();
  late String email;
  late String password;

  Future<bool> login(String email, String password) async {
    if(rememberMe){
      localStorage.write("REMEMBER_ME_EMAIL_OR_CONTACT", email);
      localStorage.write("REMEMBER_ME_PASSWORD", password);
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        return true;

      } else{
        throw ("Error");
      }
    } on FirebaseAuthException catch (e) {
      throw ("Firebase Authentication Error: ${e.code}");
    } catch (e) {
      throw ("Unexpected Error: $e");
    }
  }

  Future<bool> createAccount(String email, String username, String password) async {
    print("Email: $email\nPassword: $password");

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user;
      if (user != null) {
        return true;
      }
      else{
        return false;
      }
    } on FirebaseAuthException catch (e) {
      throw ("Firebase Authentication Error: ${e.code}");
    } catch (e) {
      throw ("Unexpected Error: $e");
    }
  }

  Future resetPassword(String email) async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e){
      print(e);
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => SignInPage());
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  (String, String) getRememberMeDetails(){
    email = localStorage.read("REMEMBER_ME_EMAIL_OR_CONTACT") ?? "";
    password = localStorage.read("REMEMBER_ME_PASSWORD") ?? "";
    return (email, password);
  }

}
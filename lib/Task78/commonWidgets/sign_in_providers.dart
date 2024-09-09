import 'package:aicp_internship/Task78/commonWidgets/custom_text.dart';
import 'package:aicp_internship/Task78/commonWidgets/sign_in_provider_button.dart';
import 'package:aicp_internship/Task78/pages/userPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class SignInProviders extends StatelessWidget{

  Future<void> addInitialUserDetails(String email, String? uid, String? profileImage, String? displayName) async {
    try {
      var db = FirebaseFirestore.instance;
      await db.collection('Users').doc(uid).set({
        "id":uid,
        "email": email,
        "profileImage": profileImage,
        "displayName": displayName
      });
      print('User details added to Firestore');
    } catch (e) {
      print('Error adding user details: $e');
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try{
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    print("Google User: $googleUser!");

    addInitialUserDetails(googleUser!.email, googleUser.id, googleUser.photoUrl, googleUser.displayName);

    final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
    );


      try{
        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        if(userCredential.user!=null){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UserPage()));
        }
      }on FirebaseAuthException catch(e){
        print(e.code.toString());
      }
    } on FirebaseAuthException catch(e){
      print(e.toString());
      rethrow;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText("Or Continue With", 20, bold:true, alignment: Alignment.center,),
        Container(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SignInProviderButton("assets/google.png", onTap: signInWithGoogle,context: context,),
            SignInProviderButton("assets/facebook.png", context: context,),
            SignInProviderButton("assets/github.png", context: context,),
          ],
        )
      ],
    );
  }

}
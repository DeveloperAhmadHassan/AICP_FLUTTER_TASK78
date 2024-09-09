import 'dart:ui';

import 'package:aicp_internship/Task78/controllers/authController.dart';
import 'package:aicp_internship/Task78/models/user.dart';
import 'package:aicp_internship/Task78/pages/updateProfilePage.dart';
import 'package:aicp_internship/Task78/utils/profilePhoto.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<AppUser?>? _userDetailsFuture;

  @override
  void initState() {
    super.initState();
    AuthController authController = AuthController();
    _userDetailsFuture = authController.getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[100],
      body: FutureBuilder<AppUser?>(
        future: _userDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return Center(child: Text("No user data found."));
          } else {
            final user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        SizedBox(
                          height: 200,
                          child: Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 140,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(30)
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    'assets/banners/b_banner.webp',
                                    width: double.infinity,
                                    height: 160,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 70,
                                left: 30,
                                child: ProfilePhoto(
                                  size: 120,
                                  profileImageUrl: user!.profilePicUrl ?? "",
                                  borderColor: Colors.cyan[100],
                                ),
                              )
                            ],
                          ),
                        ),
                        // SizedBox(height: 8),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "${user.name?['firstName']} ${user.name?['middleName']}${user.name?['lastName']}",
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Lilac',
                                  )),
                                Text(
                                  "@${user.userName}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Modernist',
                                    color: Colors.grey
                                  )),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(100)
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UpdateProfilePage(user: user),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Bootstrap.pencil_fill,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10,)
                          ],
                        ),
                        SizedBox(height: 10),
                        const Row(
                          children: [
                            Text("50 ", style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Modernist',
                            )),
                            Text("Businesses", style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Modernist',
                            )),
                            SizedBox(width: 20,),
                            Text("\u2022", style: TextStyle(
                              fontSize: 30,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Modernist',
                            )),
                            SizedBox(width: 20,),
                            Text("50 ", style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Modernist',
                            )),
                            Text("Businesses", style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Modernist',
                            )),
                          ],
                        ),
                        SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(100)
                              ),
                              child: IconButton(
                                  onPressed: (){},
                                  icon: Icon(Bootstrap.twitter_x, color: Colors.white,)
                              ),
                            ),
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(100)
                              ),
                              child: IconButton(
                                  onPressed: (){},
                                  icon: Icon(Bootstrap.facebook, color: Colors.white,)
                              ),
                            ),
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.purple,
                                    Colors.pink,
                                    Colors.orange,
                                  ],
                                ),
                                // color: color,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                  onPressed: (){},
                                  icon: Icon(Bootstrap.instagram, color: Colors.white,)
                              ),
                            ),
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(100)
                              ),
                              child: IconButton(
                                  onPressed: (){},
                                  icon: Icon(Bootstrap.threads, color: Colors.white,)
                              ),
                            ),
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: const Color(0XFF25D366),
                                  borderRadius: BorderRadius.circular(100)
                              ),
                              child: IconButton(
                                  onPressed: (){},
                                  icon: Icon(Bootstrap.whatsapp, color: Colors.white,)
                              ),
                            ),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 15, bottom: 15.0),
                                child: Text("Personal Information", style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Modernist',
                                  decorationColor: Colors.blue,
                                  decorationThickness: 2,
                                )),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Email: ",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.blue,
                                      fontFamily: 'Lilac',
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(
                                    "${user.email}",
                                    style: TextStyle(fontSize: 18, fontFamily: 'Lilac', fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Text(
                                    "City: ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue,
                                        fontFamily: 'Lilac',
                                        fontWeight: FontWeight.bold
                                    ),                                  ),
                                  Text(
                                    "${user.city}",
                                    style: TextStyle(fontSize: 18, fontFamily: 'Lilac', fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Text(
                                    "Address: ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue,
                                        fontFamily: 'Lilac',
                                        fontWeight: FontWeight.bold
                                    ),                                  ),
                                  Text(
                                    "${user.address}",
                                    style: TextStyle(fontSize: 18, fontFamily: 'Lilac', fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Text(
                                    "User Type: ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue,
                                        fontFamily: 'Lilac',
                                        fontWeight: FontWeight.bold
                                    ),                                  ),
                                  Text(
                                    switch(user.type){
                                      "B" => "Business Admin",
                                      "U" => "User",
                                      "A" => "Admin",
                                      // TODO: Handle this case.
                                      String() => "Unknown",
                                      // TODO: Handle this case.
                                      null => "Unknown",
                                    },
                                    style: TextStyle(fontSize: 18, fontFamily: 'Lilac', fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Text(
                                    "Created At: ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue,
                                        fontFamily: 'Lilac',
                                        fontWeight: FontWeight.bold
                                    ),                                  ),
                                  Text(
                                    "${DateFormat('dd/MM/yyyy').format(DateTime.parse(user.createdAt!.toString()))}",
                                    style: TextStyle(fontSize: 18, fontFamily: 'Lilac', fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Text(
                                    "Phone: ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue,
                                        fontFamily: 'Lilac',
                                        fontWeight: FontWeight.bold
                                    ),                                  ),
                                  Text(
                                    user.phone!.isEmpty ? "Not Available":"${user.phone?['completePhoneNumber']}",
                                    style: TextStyle(fontSize: 18, fontFamily: 'Lilac', fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                )
              ),
            );
          }
        },
      ),
    );
  }
}

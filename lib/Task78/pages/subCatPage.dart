import 'dart:math';

import 'package:aicp_internship/Task78/pages/SignInPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SubCatPage extends StatefulWidget {
  int state;
  SubCatPage({this.state = 0, super.key});

  @override
  State<SubCatPage> createState() => _SubCatPageState();
}

class _SubCatPageState extends State<SubCatPage> {

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const SignInPage());
    } catch (e) {
      print("Error during sign out: $e");
    }
  }

  final List<String> _educationImageAssets = [
    'assets/subcategories/education/universities.jpg',
    'assets/subcategories/education/colleges.jpg',
    'assets/subcategories/education/schools.jpg'
  ];
  final List<String> _foodImageAssets = [
    'assets/subcategories/food/desi.jpg',
    'assets/subcategories/food/sweets.jpg',
    'assets/subcategories/food/chinese.jpg',
    'assets/subcategories/food/coffee.jpg',
    'assets/subcategories/food/fast_food.jpg',
    'assets/subcategories/food/ice_cream.jpg',
  ];
  final List<String> _healthcareImageAssets = [
    'assets/subcategories/healthcare/hospitals.jpg',
    'assets/subcategories/healthcare/clinics.jpg',
    'assets/subcategories/healthcare/laboratories.jpg',
    'assets/subcategories/healthcare/specialists.jpg',
    'assets/subcategories/healthcare/blood_banks.jpg',
  ];

  final List<String> _educationSubCategoriesTitles = [
    'Universities',
    'Colleges',
    'Schools',
  ];
  final List<String> _foodSubCategoriesTitles = [
    'Desi',
    'Sweets',
    'Chinese',
    'Coffee',
    'Fast Food',
    'Ice Cream'
  ];
  final List<String> _healthcareSubCategoriesTitles = [
    'Hospitals',
    'Clinics',
    'Laboratories',
    'Specialists',
    'Blood Banks',
  ];

  final List<String> _titles = [
    "Food",
    "Healthcare",
    "Education",
    "Hotels",
  ];

  int _generateRandomNumber() {
    return Random().nextInt(100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Business Admin Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                switch(widget.state){
                  0 => _titles[0],
                  1 => _titles[1],
                  2 => _titles[2],
                  3 => _titles[3],
                  int() => "Unknown",
                },
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: switch(widget.state){
                    0 => _foodImageAssets.length,
                    1 => _healthcareImageAssets.length,
                    2 => 0,
                    3 => _educationImageAssets.length,
                    int() => throw UnimplementedError(),
                  },
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: ()=>{
                        print("$index tapped")
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                switch(widget.state){
                                  0 => _foodImageAssets[index],
                                  1 => _healthcareImageAssets[index],
                                  2 => _educationImageAssets[index],
                                  3 => _educationImageAssets[index],
                                  int() => "Unknown",
                                },
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12))
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                    switch(widget.state){
                                        0 => _foodSubCategoriesTitles[index],
                                        1 => _healthcareSubCategoriesTitles[index],
                                        2 => _educationImageAssets[index],
                                        3 => _educationSubCategoriesTitles[index],
                                        int() => "Unknown",
                                      },
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24
                                      ),
                                    ),
                                    Text(
                                      '${_generateRandomNumber()}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:aicp_internship/Task78/controllers/authController.dart';
import 'package:aicp_internship/Task78/controllers/businessController.dart';
import 'package:aicp_internship/Task78/models/user.dart';
import 'package:aicp_internship/Task78/pages/SearchPage.dart';
import 'package:aicp_internship/Task78/pages/SignInPage.dart';
import 'package:aicp_internship/Task78/pages/catgeoryBusinessPage.dart';
import 'package:aicp_internship/Task78/pages/subCatPage.dart';
import 'package:aicp_internship/Task78/utils/profilePhoto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../models/business.dart';
import 'businessDetailsPage.dart';

class HomePage extends StatefulWidget{
  int state;
  HomePage({this.state = 0, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
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
    'Coffee Shops',
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

  int selectedIndex = 0;
  AppUser? _appUser;
  bool _currentUserLoading = true;

  List<Business> _newBusinesses = [];
  bool _newBusinessesLoading = true;

  List<AppUser> _businessOwners = [];
  bool _businessOwnersLoading = true;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween<double>(begin: 1, end: 0.6).animate(_controller);
    _getCurrentUser();
    _getNewBusinesses();
    _getBusinessOwners();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _generateRandomNumber() {
    return Random().nextInt(100);
  }

  void _changeCategory(index){
    setState(() {
      selectedIndex = index;
    });
  }

  void _getCurrentUser() async{
    AuthController authController = AuthController();
    _appUser = await authController.getUserDetails();

    setState(() {
      _currentUserLoading=false;
    });
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Logout', style: TextStyle(
                color: Colors.red
              )),
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const SignInPage());
      Get.snackbar('Success', 'User Logged Out Successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.lightGreenAccent[100],
        colorText: Colors.black,
        icon: const Icon(Icons.check,),
      );
    } catch (e) {
      print("Error during sign out: $e");
      Get.snackbar('Failure', 'Error Occurred!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent[100],
        colorText: Colors.black,
        icon: const Icon(Icons.error,),
      );
    }
  }

  void _getNewBusinesses() async{
    BusinessController businessController = BusinessController();
    _newBusinesses = await businessController.getNewBusinesses(DateTime.now());
    setState(() {
      _newBusinessesLoading = false;
    });
  }

  void _getBusinessOwners() async{
    AuthController authController = AuthController();
    _businessOwners = await authController.getAllBusinessOwners();
    setState(() {
      _businessOwnersLoading = false;
    });
  }

  bool _isCollapsed = true;
  late double _screenHeight, _screenWidth;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _screenHeight = size.height;
    _screenWidth = size.width;

    return Scaffold(
      backgroundColor: Colors.cyan[50],
      body: Stack(
        children: [
          menu(context),
          dashboard(context)
        ],
      ),
    );
  }

  Widget menu(context){
    return _currentUserLoading ? const Center(child: CircularProgressIndicator()) : Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 150,),
              ProfilePhoto(size: 100, profileImageUrl: _appUser!.profilePicUrl, noBorder: true,),
              const SizedBox(height: 15,),
              Text(_appUser!.userName ?? "", style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              )),
              const SizedBox(height: 2,),
              Text(_appUser!.address ?? "", style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey
              )),
              const SizedBox(height: 35,),
              const Text("Home", style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.blue
              )),
              const Text("Settings", style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.blue
              )),
              const Text("FAQs", style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.blue
              )),
              const Spacer(),
              InkWell(
                onTap: () => _showLogoutConfirmationDialog(context),
                child: const Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red,),
                    SizedBox(width: 10,),
                    Text("Logout", style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red
                    ))
                  ],
                ),
              ),
              const SizedBox(height: 35,),
            ],
          ),
        ),
      ),
    );
  }

  Widget dashboard(context){
    return _currentUserLoading && _newBusinessesLoading ? const Center(child: CircularProgressIndicator()) : AnimatedPositioned(
      top: 0,
      bottom: 0,
      left: _isCollapsed ? 0 : 0.6 * _screenWidth,
      right: _isCollapsed ? 0 : -0.4 * _screenWidth,
      duration: const Duration(milliseconds: 300),
      child: ScaleTransition(
        scale: _animation,
        child: Material(
          elevation: 8,
          color: Colors.cyan[50],
          animationDuration: const Duration(milliseconds: 300),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 13.0, right: 13.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: (){
                            setState(() {
                              if(_isCollapsed) {
                                _controller.forward();
                              } else {
                                _controller.reverse();
                              }
                              _isCollapsed = !_isCollapsed;
                            });
                          },
                          child: Icon(
                            !_isCollapsed ? Icons.close : Icons.menu,
                            size: 25,
                            color: Colors.blue,
                          )
                      ),
                      // Text("Business"),
                      InkWell(
                          onTap: (){
                            // setState(() {
                            //   _isCollapsed = !_isCollapsed;
                            // });
                          },
                          child: Icon(
                            Icons.settings,
                            size: 25,
                            color: Colors.blue,
                          )
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SearchPage()),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100)
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 18.0),
                              child: Text("Find Your Desired Business", style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                                fontFamily: 'Modernist',
                              )),
                            ),
                            Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.blue[400],
                                  borderRadius: BorderRadius.circular(100)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.search, color: Colors.white,),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Explore Our Categories",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue,
                      fontFamily: 'Modernist',
                    ),
                  ),
                ),
                SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _titles.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(left: index == 0 ? 8.0: 0.0),
                          child: InkWell(
                            onTap: () => _changeCategory(index),
                            child: Container(
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(_titles[index], style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Modernist',
                                  color: selectedIndex == index ? Colors.blue : Colors.black,
                                  decoration: selectedIndex == index ? TextDecoration.underline : null,
                                  decorationColor: Colors.blue,
                                  decorationStyle: TextDecorationStyle.solid,
                                  decorationThickness: 3
                              )),
                            ),
                          ),
                        );
                      },
                    )
                ),
                SizedBox(
                  height: 250,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: switch(selectedIndex){
                      0 => _foodImageAssets.length,
                      1 => _healthcareImageAssets.length,
                      2 => _educationImageAssets.length,
                      3 => 1,
                      int() => throw UnimplementedError(),
                    },
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryBusinessPage(category: switch(selectedIndex){
                                0 => _foodSubCategoriesTitles[index],
                                1 => _healthcareSubCategoriesTitles[index],
                                2 => _educationSubCategoriesTitles[index],
                                3 => "hotels",
                                int() => throw UnimplementedError(),
                              }),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 2,
                          child: Container(
                            margin: const EdgeInsets.all(8.0),
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    switch(selectedIndex){
                                      0 => _foodImageAssets[index],
                                      1 => _healthcareImageAssets[index],
                                      2 => _educationImageAssets[index],
                                      3 => _foodImageAssets[index],
                                      int() => throw UnimplementedError(),
                                    },
                                    width: double.infinity,
                                    height: 160,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            switch(selectedIndex){
                                              0 => _foodSubCategoriesTitles[index],
                                              1 => _healthcareSubCategoriesTitles[index],
                                              2 => _educationSubCategoriesTitles[index],
                                              3 => "",
                                              int() => throw UnimplementedError(),
                                            },
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 24,
                                              fontFamily: 'Lilac',
                                            ),
                                          ),
                                          Text(
                                            "Explore More",
                                            style: const TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              fontFamily: 'Modernist',
                                              decoration: TextDecoration.underline,
                                              decorationColor: Colors.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '${_generateRandomNumber()}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                          fontFamily: 'Lilac',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                if(_businessOwnersLoading)
                  const Padding(
                    padding: EdgeInsets.all(13.0),
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.blue,),
                    ),
                  )
                else
                  ...[
                    _businessOwners != null ? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Meet Our Business Owners",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontFamily: 'Lilac',
                        ),
                      ),
                    ) : Container(),
                    SizedBox(
                      height: 170,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _businessOwners.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => SubCatPage(state: index),
                                //   ),
                                // );
                              },
                              child: Container(
                                margin: const EdgeInsets.all(8.0),
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ProfilePhoto(size: 90, profileImageUrl: _businessOwners[index].profilePicUrl ?? "", noBorder: true,),
                                      const SizedBox(height: 8.0),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              _businessOwners[index].userName ?? "",
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                fontFamily: 'Modernist',
                                              ),
                                            ),
                                            Text(
                                              _businessOwners[index].address ?? "",
                                              style: const TextStyle(
                                                color: Colors.blueGrey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                fontFamily: 'Modernist',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                          );
                        },
                      ),
                    ),
                  ],

                if(_newBusinessesLoading)
                  const Padding(
                    padding: EdgeInsets.all(13.0),
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.blue,),
                    ),
                  )
                else
                  ...[
                    _newBusinesses != null ? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Recently Added Businesses",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                          fontFamily: 'Lilac',
                        ),
                      ),
                    ) : Container(),
                    SizedBox(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _newBusinesses.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => BusinessDetailsPage(business: _newBusinesses[index])),
                                );
                            },
                            child: Card(
                              color: Colors.white,
                              elevation: 2,
                              child: Container(
                                margin: const EdgeInsets.all(8.0),
                                width: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        _newBusinesses[index].indexImage,
                                        width: double.infinity,
                                        height: 160,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                _newBusinesses[index].name,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  fontFamily: 'Lilac',
                                                ),
                                              ),
                                              Text(
                                                _newBusinesses[index].address ?? "",
                                                style: const TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  fontFamily: 'Lilac',
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          const Icon(Icons.star, color: Colors.blue,),
                                          SizedBox(width: 5,),
                                          Text(_newBusinesses[index].overallRating.toString(), style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Lilac',
                                          ))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],

              ],
            ),
          ),
        ),
      ),
    );
  }
}

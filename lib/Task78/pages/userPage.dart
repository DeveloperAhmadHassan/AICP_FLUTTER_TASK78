import 'package:aicp_internship/Task78/models/user.dart';
import 'package:aicp_internship/Task78/pages/SearchPage.dart';
import 'package:aicp_internship/Task78/pages/SignInPage.dart';
import 'package:aicp_internship/Task78/pages/businessPage.dart';
import 'package:aicp_internship/Task78/pages/profilePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../controllers/authController.dart';
import 'SignUpPage.dart';
import 'homePage.dart';

class UserPage extends StatefulWidget {
  int state;
  UserPage({this.state = 0, super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int _selectedIndex = 0;
  AppUser _appUser = AppUser();
  bool _currentUserLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() async{
    AuthController authController = AuthController();
    _appUser = (await authController.getUserDetails())!;

    setState(() {
      _currentUserLoading=false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      HomePage(),
      _appUser.type == 'B' ? BusinessPage() : SearchPage(),
      ProfilePage(),
    ];
    return Scaffold(
      body: _currentUserLoading ? CircularProgressIndicator() : _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.cyan[300],
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _appUser.type == 'B' ? Icon(Icons.business) : Icon(Icons.search),
            label: _appUser.type == 'B' ? 'My Businesses' : "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        iconSize: 28,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          fontFamily: 'Lilac',
        ),
        onTap: _onItemTapped,
      ),
    );
  }

}

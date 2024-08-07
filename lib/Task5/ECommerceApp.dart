import 'package:aicp_internship/Task5/pages/CartPage.dart';
import 'package:aicp_internship/Task5/pages/ECommerceHomePage.dart';
import 'package:flutter/material.dart';

import 'pages/WishListPage.dart';


class ECommerceScreen extends StatefulWidget {
  const ECommerceScreen({super.key});

  @override
  _ECommerceScreenState createState() => _ECommerceScreenState();
}

class _ECommerceScreenState extends State<ECommerceScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTapBottomNavigationBar(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          const ECommerceHomeScreen(),
          const CartPage(cartItems: []),
          WishListPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        selectedItemColor: Colors.blue,
        currentIndex: _currentIndex,
        onTap: _onTapBottomNavigationBar,
      ),
    );
  }
}

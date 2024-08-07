import 'package:aicp_internship/Task5/controllers/DBHelper.dart';
import 'package:aicp_internship/Task5/pages/FeedbackPage.dart';
import 'package:aicp_internship/Task5/pages/InquiriesPage.dart';
import 'package:flutter/material.dart';
import '../models/CartItem.dart';
import 'CartPage.dart';
import '../controllers/ProductService.dart';

class ECommerceHomeScreen extends StatefulWidget {
  const ECommerceHomeScreen({super.key});

  @override
  _ECommerceHomeScreenState createState() => _ECommerceHomeScreenState();
}

class _ECommerceHomeScreenState extends State<ECommerceHomeScreen> {
  late List<dynamic> _products = [];
  late List<dynamic> _categories = [];
  List<CartItem> _cartItems = [];
  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final ProductService _productService = ProductService();
  bool _isLoading = true;
  bool _isLoadingCategories = true;
  String _selectedCategory = '';

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _fetchCategories();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchQuery = '';
        _searchController.clear();
      }
    });
  }
  void _fetchProducts({String query = ''}) async {
    try {
      List<dynamic> products = await _productService.fetchAllProducts(query: query);
      // products.removeAt(4);
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
      _isLoading = false;
    }
  }

  void _fetchCategories() async {
    try {
      List<dynamic> categories = await _productService.fetchAllCategories();
      setState(() {
        _categories = categories;
        _isLoadingCategories = false;
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  void _addToCart(String title, String imgSrc, double price) {
    setState(() {
      _cartItems.add(CartItem(title: title, imgSrc: imgSrc, price: price));
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item Added to Cart!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _deleteFromCart(String title) {
    setState(() {
      _cartItems.removeWhere((element) => element.title == title);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item Deleted From Cart!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  bool _checkItemInCart(String title) =>
      _cartItems.any((item) => item.title == title);

  Future<bool> _checkItemInWishList(int pid) async {
    bool productExists = await DatabaseHelper().isProductExists(pid);
    return productExists;
  }

  void _navigateToCartPage(BuildContext context){
    ScaffoldMessenger.of(context).clearSnackBars();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(cartItems: _cartItems),
      ),
    );
  }

  void _showProductsByCategory(String category) async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<dynamic> products = await _productService.fetchAllProductsByCategory(category);
      setState(() {
        _selectedCategory = category=='All' ? 'All' : category;
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching products by category: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  void _onSearchSubmitted(String query) {
    if (query.isNotEmpty) {
      setState(() {
        _isLoading = true;
        _selectedCategory = '0';
      });
      _fetchProducts(query: query);
      _toggleSearch();
    }
  }
  void _addProductToWishlist(String title, int pid, String imageUrl) async {
    print("Here");
    await DatabaseHelper().addProduct(
      title,
      pid,
      DateTime.now().toIso8601String(),
      imageUrl,
    );

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product Added to WishList!'), backgroundColor: Colors.green,),
    );
  }

  void _removeProductFromWishlist(int pid) async {
    await DatabaseHelper().deleteProduct(
        pid
    );

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product Removed to WishList!'), backgroundColor: Colors.green,),
    );
  }

  Future<void> _handleWishlistButtonPress(String title, int pid, String imageUrl) async {
    bool isInWishlist = await _checkItemInWishList(pid);
    if (isInWishlist) {
      _removeProductFromWishlist(pid);
      setState(() {

      });
    } else {
      _addProductToWishlist(title, pid, imageUrl);
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search product',
            border: InputBorder.none,
          ),
          onSubmitted: _onSearchSubmitted,
        )
            : Text("ECommerce App", style: TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          _isSearching
              ? Container()
              : IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              _navigateToCartPage(context);
            },
          ),
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 18.0, left: 8.0),
        child: Column(
          children: [
            _isLoadingCategories
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: [
                    _categoryCard(
                      title: 'All',
                      selected: _selectedCategory.isEmpty || _selectedCategory == 'All',
                      onTap: () => _showProductsByCategory('All'),
                    ),
                    ..._categories.map<Widget>((item) {
                      return _categoryCard(
                        title: item,
                        selected: item == _selectedCategory,
                        onTap: () => _showProductsByCategory(item),
                      );
                    }).toList(),
                  ]
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : Expanded(
              child: _products.isEmpty
                  ? Center(child: Text("No Products Found!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)))
                  : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  mainAxisExtent: 320,
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final item = _products[index];
                  return _productCard(
                    item['id'],
                    item["title"],
                    item["image"],
                    double.parse(item['price'].toString()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showSupportDialog,
        child: Icon(Icons.help),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showSupportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Customer Support'),
          content: Text('How can we assist you? Please choose an option below.'),
          actions: [
            TextButton(
              child: Text('Feedback'),
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToFeedbackPage();
              },
            ),
            TextButton(
              child: Text('Inquiries'),
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToInquiriesPage();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToFeedbackPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FeedbackPage()),
    );
  }

  void _navigateToInquiriesPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InquiriesPage()),
    );
  }


  Widget _categoryCard({required String title, required bool selected, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 13.0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 7,
          color: selected ? Colors.blue : Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 20.0, right: 20.0),
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: selected ? Colors.white : Colors.black,
                decoration: selected ? TextDecoration.underline : null,
                decorationStyle: TextDecorationStyle.solid,
                decorationThickness: 3,
                decorationColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _productCard(int pid, String title, String imgSrc, double price) {
    return Padding(
      padding: const EdgeInsets.only(right: 18.0),
      child: Container(
        width: 200,
        height: 380,
        child: Card(
          elevation: 7,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 13.0),
                  child: Image.network(
                    "$imgSrc",
                    width: 90,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 13.0, bottom: 6.0),
                  child: Text(
                    "$title",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text("\$$price", style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600
                )),
                Spacer(),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          _checkItemInCart(title) ?_deleteFromCart(title) : _addToCart(title, imgSrc, price);
                        },
                        icon: _checkItemInCart(title) ? Icon(Icons.shopping_cart_sharp) : Icon(Icons.shopping_cart_outlined)
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () => _handleWishlistButtonPress(title, pid, imgSrc),
                      icon: FutureBuilder<bool>(
                        future: _checkItemInWishList(pid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else {
                            if (snapshot.hasData && snapshot.data!) {
                              return Icon(Icons.favorite, color: Colors.red);
                            } else {
                              return Icon(Icons.favorite_border);
                            }
                          }
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

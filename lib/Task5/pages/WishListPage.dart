import 'package:aicp_internship/Task5/controllers/DBHelper.dart';
import 'package:flutter/material.dart';

class WishListPage extends StatefulWidget {
  @override
  _WishListPageState createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  late Future<List<Map<String, dynamic>>> _wishListItems;

  @override
  void initState() {
    super.initState();
    _loadWishListItems();
  }

  Future<void> _loadWishListItems() async {
    setState(() {
      _wishListItems = DatabaseHelper().fetchProducts();
    });
  }

  void deleteItem(int pid) async{
    await DatabaseHelper().deleteProduct(pid);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item Deleted from Wishlist!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wish List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _wishListItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items in wish list'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return ListTile(
                  title: Text(item['title']),
                  leading: Image.network(item['imageUrl']),
                  subtitle: Text('Product ID: ${item['pid']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      deleteItem(item['pid']);
                      _loadWishListItems();
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/CartItem.dart';

class CartPage extends StatefulWidget {
  final List<CartItem> cartItems;

  const CartPage({super.key, required this.cartItems});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  void _deleteFromCart(String title) {
    setState(() {
      widget.cartItems.removeWhere((element) => element.title == title);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item Deleted From Cart!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _increaseQuantity(CartItem item) {
    if (item.quantity < 100) {
      setState(() {
        item.quantity++;
      });
    }
  }

  void _decreaseQuantity(CartItem item) {
    if (item.quantity > 1) {
      setState(() {
        item.quantity--;
      });
    }
  }

  double _calculateGrandTotal() {
    double total = 0;
    for (var item in widget.cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }

  void _handleCheckout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thank You!'),
          content: Text('Thank you for your purchase!'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  widget.cartItems.clear();
                });
                // Navigator.pushReplacement(context, newRoute);
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Column(
        children: [
          Expanded(
            child: widget.cartItems.isEmpty
                ? Center(child: Text("Your cart is empty"))
                : ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return ListTile(
                  leading: Image.network(item.imgSrc),
                  title: Text(item.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price: \$${item.price.toStringAsFixed(2)}'),
                      Text('Total: \$${(item.price * item.quantity).toStringAsFixed(2)}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () => _decreaseQuantity(item),
                      ),
                      Text(item.quantity.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => _increaseQuantity(item),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_shopping_cart),
                        onPressed: () => _deleteFromCart(item.title),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          widget.cartItems.isEmpty ? Container() : _cartSummary(),
        ],
      ),
    );
  }

  Widget _cartSummary() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -1),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Grand Total',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${_calculateGrandTotal().toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              onPressed: _handleCheckout,
              child: Text('Check Out', style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: Colors.white
              )),
            ),
          )
        ],
      ),
    );
  }
}

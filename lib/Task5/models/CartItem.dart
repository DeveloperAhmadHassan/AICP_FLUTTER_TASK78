class CartItem {
  final String title;
  final String imgSrc;
  int quantity;
  final double price;

  CartItem({
    required this.title,
    required this.imgSrc,
    this.quantity = 1,
    required this.price,
  });
}

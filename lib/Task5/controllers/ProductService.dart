import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductService {
  static String? apiUrl = dotenv.env['ECOMMERCE_API_URL'];

  Future<List<dynamic>> fetchAllProducts({String query = ''}) async {
    final response = await http.get(Uri.parse(("${apiUrl!}/products")!));

    if (response.statusCode == 200) {
      List<dynamic> jsonBody = jsonDecode(response.body);

      if (query.isNotEmpty) {
        jsonBody = jsonBody.where((product) =>
            product['title'].toString().toLowerCase().contains(query.toLowerCase())).toList();
      }

      return jsonBody;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<dynamic>> fetchAllCategories() async {
    final response = await http.get(Uri.parse(("${apiUrl!}/products/categories")!));

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      return jsonBody;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<dynamic>> fetchAllProductsByCategory(String category) async {
    if(category == 'All'){
      return fetchAllProducts();
    }
    final response = await http.get(Uri.parse(("${apiUrl!}/products/category/$category")!));

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      return jsonBody;
    } else {
      throw Exception('Failed to load categories');
    }
  }
}

import 'dart:convert';
import 'package:aicp_internship/Task2/Quote.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class QuoteService {
  static String? apiKey = dotenv.env['QUOTE_API_KEY'];
  static String? apiUrl = dotenv.env['QUOTE_API_URL'];

  Future<Quote> fetchQuote() async {
    final response = await http.get(Uri.parse(apiUrl ?? ""), headers: {
      'X-Api-Key': apiKey ?? "",
    });
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      print(jsonBody);
      return Quote.fromJson(jsonBody[0]);
    } else {
      throw Exception('Failed to load quote');
    }
  }
}

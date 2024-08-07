import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  static String? apiUrl = dotenv.env['WEATHER_API_URL'];
  static String? apiKey = dotenv.env['WEATHER_API_KEY'];


  Future<Map<dynamic, dynamic>> fetchWeather(String city) async {
    final response = await http.get(Uri.parse("$apiUrl?key=$apiKey&q=$city&days=7&aqi=yes&alerts=yes"));

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      return jsonBody;
    } else {
      throw Exception('FFFailed to load weather data');
    }
  }
}

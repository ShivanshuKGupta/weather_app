import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class Weather {
  double lat = 28.7041;
  double lon = 77.1025;
  final String apiKey = "0db6f206e814468a0f710b8816b6a091";

  static final instance = Weather();
  Map<String, dynamic> currentWeatherData = {},
      hourlyForecastData = {},
      currentAirPollutionData = {};
  String cityName = "";

  Future<Map<String, dynamic>> getCurrentWeatherData() async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey"));
    final body = json.decode(response.body);
    log("Response from OpenWeatherApi: $body");
    if (response.statusCode != 200) {
      if (body is Map && body.containsKey('message')) {
        throw body['message'];
      }
      throw body;
    }
    return currentWeatherData = body;
  }

  Future<Map<String, dynamic>> call5Day3HourForecastData() async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey"));
    final body = json.decode(response.body);
    log("Response from OpenWeatherApi: $body");
    if (response.statusCode != 200) {
      if (body is Map && body.containsKey('message')) {
        throw body['message'];
      }
      throw body;
    }
    return hourlyForecastData = body;
  }

  Future<Map<String, dynamic>> getCurrentAirPollutionData() async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/air_pollution?lat=$lat&lon=$lon&appid=$apiKey"));
    final body = json.decode(response.body);
    log("Response from OpenWeatherApi: $body");
    if (response.statusCode != 200) {
      if (body is Map && body.containsKey('message')) {
        throw body['message'];
      }
      throw body;
    }
    return currentAirPollutionData = body;
  }

  Future<String> getReverseGeocoding() async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/geo/1.0/reverse?lat=$lat&lon=$lon&limit=1&appid=$apiKey"));
    final body = json.decode(response.body);
    log("Response from OpenWeatherApi: $body");
    if (response.statusCode != 200) {
      if (body is Map && body.containsKey('message')) {
        throw body['message'];
      }
      throw body;
    }
    return cityName = body[0]['name'];
  }
}

import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  // This class fetches data with apikey
  // Get the user's city
  // Visit https://openweathermap.org/current for more information regarding the json

  // baseUrl of the api
  static const baseUrl = "https://api.openweathermap.org/data/2.5/weather";
  // apiKey for the data
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    // This method gets the weather from the website and returns the weather model
    // which includes all the weather information.
    // Using the baseUrl, apikey, and http,
    // get the json from the website
    // convert into a weather model, and return it

    final response = await http
        .get(Uri.parse("$baseUrl?q=$cityName&appid=$apiKey&units=metric"));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("failed to load weather data");
    }
  }

  Future<String> getCurrentCity() async {
    // method that gets the user's current city
    // using Geolocator
    // check whether permission is confirmed or denied
    // if confirmed, get the city's name and
    // return the current cityname of the device

    // get permission
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // but if denied, try again
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        // Still denied
        // This is where app should show explanatory UI
        return Future.error("Location permissions are denied");
      }
    }

    // fetch the current location in latitude and longitude
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // convert the latitude and longitude into a list of placemark objects
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    // extract the city name from the first placemark. locality is the name of the city associated with the placemark
    // https://pub.dev/documentation/geocoding/latest/geocoding/Placemark-class.html for more info
    String? city = placemarks[0].locality;

    // if it's null, return a blank string
    return city ?? "";
  }
}

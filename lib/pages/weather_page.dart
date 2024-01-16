import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api Key
  final _weatherService = WeatherService('0d4292bd55c8d96c427eea46e993e0d1');
  Weather? _weather;

  // Conditions that can be on Api Data
  // refer to https://openweathermap.org/weather-conditions
  Map<String, List<dynamic>> conditions = {
    "thunderstorm": ["assets/thunderstorm.json", Colors.grey.shade900],
    "clouds": ["assets/cloud.json", Colors.blueGrey.shade400],
    "snow": ["assets/snow.json", Colors.amber.shade50],
    "drizzle": ["assets/drizzle.json", Colors.blueGrey.shade400],
    "sunny": ["assets/sunny.json", Colors.lightBlue.shade100],
  };

  void _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    // get weather for the city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    // any errors
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          e.toString(),
        ),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  String? getWeatherAnimation(String? mainCondition) {
    // The first letter in mainCondition is capital, so make it all lowercase
    mainCondition = mainCondition?.toLowerCase();
    // if mainCondition is not in the map, return null
    return conditions[mainCondition]?[0];
  }

  Color? getBackgroundColor(String? condition) {
    condition = condition?.toLowerCase();
    return conditions[condition]?[1];
  }

  Color getTextColor(bool isMainText, String? condition) {
    // This method returns the color for any UI on the screen
    // isMainText: true if it's necessary info, false if not

    condition = condition?.toLowerCase();
    if (isMainText == true) {
      if (conditions[condition]?[1] == Colors.grey.shade900 ||
          conditions[condition]?[1] == Colors.blueGrey.shade400) {
        // If thunderstorm or clouds
        return Colors.white;
      } else {
        return Colors.black;
      }
    } else {
      if (conditions[condition]?[1] == Colors.grey.shade900 ||
          conditions[condition]?[1] == Colors.blueGrey.shade400) {
        // If thunderstorm or clouds
        return Colors.white70;
      } else {
        return Colors.grey;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBackgroundColor(_weather?.mainCondition),
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on,
                  size: 30,
                  color: getTextColor(true, _weather?.mainCondition),
                ),
                Text(
                  _weather?.cityName ?? "loading city...",
                  style: TextStyle(
                    fontSize: 30,
                    color: getTextColor(true, _weather?.mainCondition),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 300,
                  height: 300,
                  child: Lottie.asset(
                    getWeatherAnimation(_weather?.mainCondition) ??
                        "assets/sunny.json",
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  "  ${_weather?.temperature.round()}º",
                  style: TextStyle(
                    fontSize: 50,
                    color: getTextColor(true, _weather?.mainCondition),
                  ),
                ),
                Text(
                  "${_weather?.minTemp} / ${_weather?.maxTemp}",
                  style: TextStyle(
                    fontSize: 30,
                    color: getTextColor(false, _weather?.mainCondition),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  _weather?.mainCondition ?? "...",
                  style: TextStyle(
                    fontSize: 20,
                    color: getTextColor(true, _weather?.mainCondition),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Icon(
            // TODO: Implement fade in and out animation
            Icons.arrow_downward_rounded,
            size: 30,
            color: getTextColor(true, _weather?.mainCondition),
          ),
          SizedBox(
            height: 600,
          ),
        ],
      ),
    );
  }
}

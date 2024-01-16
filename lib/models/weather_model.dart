class Weather {
  // This class represents a model with all the information about the weather
  // Currently has these attributes: cityname, temperature, and maincondition
  // Can add more information about the weather.

  final String cityName;
  final double temperature;
  final String mainCondition;
  final double minTemp;
  final double maxTemp;

  Weather.fromJson(Map<String, dynamic> json)
      : cityName = json['name'],
        temperature = json['main']['temp'].toDouble(),
        mainCondition = json['weather'][0]['main'],
        minTemp = json['main']['temp_min'].toDouble(),
        maxTemp = json['main']['temp_max'].toDouble();
}

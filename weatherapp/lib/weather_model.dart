class Weather {
  final String cityName;
  final String country;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final int windDirection;
  final double feelsLike;
  final int pressure;
  final int visibility;
  final int cloudiness;
  final int sunrise;
  final int sunset;
  final String icon;

  Weather({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.feelsLike,
    required this.pressure,
    required this.visibility,
    required this.cloudiness,
    required this.sunrise,
    required this.sunset,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      country: json['sys']['country'],
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      windDirection: json['wind']['deg'],
      feelsLike: json['main']['feels_like'].toDouble(),
      pressure: json['main']['pressure'],
      visibility: json['visibility'],
      cloudiness: json['clouds']['all'],
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
      icon: json['weather'][0]['icon'],
    );
  }
}

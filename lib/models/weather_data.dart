import 'dart:developer';

class WeatherData {
  String? weatherDescription;
  DateTime? dt;
  String? weatherIcon;
  double? feelsLike;
  double? minTemp;
  double? temp;
  double? maxTemp;
  double? pressure;
  double? humidity;
  double? visibility;
  double? windSpeed;
  double? windDeg;
  double? windGust;
  double? clouds;

  fromJson(Map<String, dynamic> data) {
    log("Assigning dt ");
    dt = !(data.containsKey('dt'))
        ? null
        : DateTime.now(); // .fromMillisecondsSinceEpoch(data['dt'])
    log("Assigning weatherDescription ");
    weatherDescription = !(data.containsKey('weather') &&
            data['weather'][0].containsKey('description'))
        ? null
        : data['weather'][0]['description'];
    log("Assigning weatherIcon ");
    weatherIcon =
        !(data.containsKey('weather') && data['weather'][0].containsKey('icon'))
            ? null
            : data['weather'][0]['icon'];
    log("Assigning minTemp ");
    minTemp =
        !(data.containsKey('main') && data['main'].containsKey('temp_min'))
            ? null
            : (data['main']['temp_min'] - 273).toDouble();
    log("Assigning feelsLike ");
    feelsLike =
        !(data.containsKey('main') && data['main'].containsKey('feels_like'))
            ? null
            : (data['main']['feels_like'] - 273).toDouble();
    log("Assigning temp ");
    temp = !(data.containsKey('main') && data['main'].containsKey('temp'))
        ? null
        : (data['main']['temp'] - 273).toDouble();
    log("Assigning maxTemp ");
    maxTemp =
        !(data.containsKey('main') && data['main'].containsKey('temp_max'))
            ? null
            : (data['main']['temp_max'] - 273).toDouble();
    log("Assigning pressure ");
    pressure =
        !(data.containsKey('main') && data['main'].containsKey('pressure'))
            ? null
            : (data['main']['pressure']).toDouble();
    log("Assigning humidity ");
    humidity =
        !(data.containsKey('main') && data['main'].containsKey('humidity'))
            ? null
            : (data['main']['humidity']).toDouble();
    log("Assigning visibility ");
    visibility = !(data.containsKey('visibility'))
        ? null
        : (data['visibility']).toDouble();
    log("Assigning windSpeed ");
    windSpeed = !(data.containsKey('wind') && data['wind'].containsKey('speed'))
        ? null
        : (data['wind']['speed']).toDouble();
    log("Assigning windDeg ");
    windDeg = !(data.containsKey('wind') && data['wind'].containsKey('deg'))
        ? null
        : (data['wind']['deg']).toDouble();
    log("Assigning windGust ");
    windGust = !(data.containsKey('wind') && data['wind'].containsKey('gust'))
        ? null
        : (data['wind']['gust'] ?? 0).toDouble();
    log("Assigning clouds ");
    clouds = !(data.containsKey('clouds') && data['clouds'].containsKey('all'))
        ? null
        : (data['clouds']['all'] ?? 0).toDouble();
  }
}

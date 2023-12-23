import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:weather_app/auth/screens/edit_profile_screen.dart';
import 'package:weather_app/dashboard/widgets/weather_tile.dart';
import 'package:weather_app/models/aqi.dart';
import 'package:weather_app/models/globals.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/utils/utils.dart';
import 'package:weather_app/utils/widgets/profile_image.dart';

class DashboardScreen extends StatefulWidget {
  final LocationData? locationData;
  const DashboardScreen({super.key, this.locationData});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int userFetchRetry = 0;
  String? error;

  @override
  void initState() {
    super.initState();
    Weather.instance.lat =
        (widget.locationData == null || widget.locationData!.latitude == null)
            ? Weather.instance.lat
            : widget.locationData!.latitude!;
    Weather.instance.lon =
        (widget.locationData == null || widget.locationData!.longitude == null)
            ? Weather.instance.lon
            : widget.locationData!.longitude!;
    Weather.instance.getCurrentWeatherData().then((value) {
      setState(() {});
    }).onError((error, stackTrace) {
      setState(() => this.error = error.toString());
    });
    Weather.instance.call5Day3HourForecastData().then((value) {
      setState(() {});
    }).onError((error, stackTrace) {
      setState(() => this.error = error.toString());
    });
    Weather.instance.getCurrentAirPollutionData().then((value) {
      setState(() {});
    }).onError((error, stackTrace) {
      setState(() => this.error = error.toString());
    });
    Weather.instance.getReverseGeocoding().then((value) {
      setState(() {});
    }).onError((error, stackTrace) {
      setState(() => this.error = error.toString());
    });
  }

  int refreshCount = 0;
  @override
  Widget build(BuildContext context) {
    final weatherData = WeatherData()
      ..fromJson(Weather.instance.currentWeatherData);
    final aqiData =
        AirQuality.fromJson(Weather.instance.currentAirPollutionData);
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: ShaderWidget(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black54,
                colorScheme.background,
              ],
              child: Container(
                color: Colors.white,
              ),
            ),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text(
                Weather.instance.cityName.isEmpty
                    ? ""
                    : Weather.instance.cityName,
              ),
              backgroundColor: Colors.transparent,
              actions: [
                FutureBuilder(
                  key: ValueKey("userFetchRetry$userFetchRetry"),
                  future: currentUser.fetch(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.only(right: 15.0),
                        child: CircularProgressIndicatorRainbow(),
                      );
                    } else if (snapshot.hasError) {
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            userFetchRetry++;
                          });
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.red,
                        ),
                      );
                    }
                    return SizedBox(
                      height: 56,
                      width: 56,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ProfileImage(
                          gender: currentUser.gender ?? 0,
                          radius: 500,
                          img: currentUser.imgUrl == null
                              ? null
                              : Image.network(
                                  currentUser.imgUrl!,
                                  fit: BoxFit.cover,
                                ),
                          onTap: () async {
                            await navigatorPush(
                              context,
                              EditProfileScreen(
                                user: currentUser,
                              ),
                            );
                            setState(() {});
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() => refreshCount++);
                },
                child: (error != null)
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "${((weatherData.temp ?? 0)).toStringAsFixed(0)}°",
                                  style: textTheme.displayLarge,
                                  textAlign: TextAlign.center,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "Feels like ${(weatherData.feelsLike ?? 0).toStringAsFixed(0)}°",
                                      style: textTheme.bodyMedium,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  weatherData.weatherDescription
                                      .toString()
                                      .toPascalCase(),
                                  style: textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                                if (weatherData.weatherIcon != null)
                                  Image.network(
                                    'http://openweathermap.org/img/w/${weatherData.weatherIcon}.png',
                                  ),
                              ],
                            ),
                            // const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: GridView.extent(
                                maxCrossAxisExtent: 100,
                                mainAxisSpacing: 0,
                                crossAxisSpacing: 10,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  WeatherTile(
                                    icon: const Icon(Icons.thermostat_rounded),
                                    title: "Feels Like",
                                    value:
                                        weatherData.temp?.toStringAsFixed(0) ??
                                            "0",
                                    unit: 'deg',
                                  ),
                                  WeatherTile(
                                    icon: const Icon(Icons.sunny_snowing),
                                    title: "Min Temp",
                                    value: weatherData.minTemp
                                            ?.toStringAsFixed(0) ??
                                        "0",
                                    unit: 'deg',
                                  ),
                                  WeatherTile(
                                    icon: const Icon(Icons.sunny),
                                    title: "Max Temp",
                                    value: weatherData.maxTemp
                                            ?.toStringAsFixed(0) ??
                                        "0",
                                    unit: 'deg',
                                  ),
                                  WeatherTile(
                                    icon: const Icon(Icons.air_rounded),
                                    title: "Pressure",
                                    value: weatherData.pressure.toString(),
                                    unit: 'hPa',
                                  ),
                                  WeatherTile(
                                    icon: const Icon(Icons.opacity),
                                    title: "Humidity",
                                    value: weatherData.humidity.toString(),
                                    unit: '%',
                                  ),
                                  WeatherTile(
                                    icon: const Icon(Icons.wind_power_rounded),
                                    title: "Wind Speed",
                                    value: weatherData.windSpeed.toString(),
                                    unit: 'km/h',
                                  ),
                                  WeatherTile(
                                    icon: const Icon(Icons.waves),
                                    title: "Wind Gust",
                                    value: weatherData.windGust.toString(),
                                    unit: 'km/h',
                                  ),
                                  WeatherTile(
                                    icon: const Icon(Icons.explore_rounded),
                                    title: "Wind Deg",
                                    value: weatherData.windDeg.toString(),
                                    unit: 'deg',
                                  ),
                                  WeatherTile(
                                    icon: const Icon(Icons.cloud_rounded),
                                    title: "Clouds",
                                    value: weatherData.clouds.toString(),
                                    unit: '%',
                                  ),
                                ],
                              ),
                            ),
                            if (Weather.instance.hourlyForecastData.isNotEmpty)
                              Text(
                                '5 Day Forecast',
                                style: textTheme.titleLarge,
                              ),
                            const SizedBox(height: 20),
                            if (Weather.instance.hourlyForecastData.isNotEmpty)
                              SizedBox(
                                height: 120,
                                child: ListView.separated(
                                  itemBuilder: (context, index) {
                                    final data = WeatherData()
                                      ..fromJson(Weather.instance
                                          .hourlyForecastData['list'][index]);
                                    data.dt = data.dt!
                                        .add(Duration(hours: 3 * (index + 1)));
                                    return GlassWidget(
                                      radius: 10,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        color: colorScheme.surface
                                            .withOpacity(0.4),
                                        child: Column(
                                          children: [
                                            Text(
                                              "${data.dt!.hour}:00",
                                              style: textTheme.bodyMedium,
                                            ),
                                            Text(
                                              "${data.dt!.day} ${getMonth(data.dt!.month)}",
                                              style: textTheme.bodySmall,
                                            ),
                                            Image.network(
                                              'http://openweathermap.org/img/w/${data.weatherIcon}.png',
                                              fit: BoxFit.contain,
                                            ),
                                            Text(
                                              "${((data.temp ?? 0)).toStringAsFixed(0)}°",
                                              style: textTheme.bodyMedium,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(width: 10),
                                  itemCount: 8 * 5,
                                  scrollDirection: Axis.horizontal,
                                ),
                              ),
                            const SizedBox(height: 20),
                            if (Weather
                                .instance.currentAirPollutionData.isNotEmpty)
                              Text(
                                'Air Quality',
                                style: textTheme.titleLarge,
                              ),
                            if (Weather
                                .instance.currentAirPollutionData.isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: GridView.extent(
                                  maxCrossAxisExtent: 100,
                                  mainAxisSpacing: 0,
                                  crossAxisSpacing: 10,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  children: [
                                    WeatherTile(
                                      icon: const Icon(
                                          Icons.remove_red_eye_rounded),
                                      title: "Visibility",
                                      value: weatherData.visibility.toString(),
                                      unit: 'km',
                                    ),
                                    WeatherTile(
                                      icon: const Icon(Icons.cloud_circle),
                                      title: "Air Quality Index",
                                      value: aqiData.aqi.toString(),
                                      unit: 'km',
                                    ),
                                    WeatherTile(
                                      icon: const Icon(Icons.blur_on),
                                      title: "Particulate Matter (2.5)",
                                      value: aqiData.pm2_5.toString(),
                                      unit: 'km',
                                    ),
                                    WeatherTile(
                                      icon: const Icon(Icons.blur_circular),
                                      title: "Particulate Matter (10)",
                                      value: aqiData.pm10.toString(),
                                      unit: 'km',
                                    ),
                                    WeatherTile(
                                      icon: const Icon(Icons.cloud_queue),
                                      title: "Carbon Monoxide",
                                      value: aqiData.co.toString(),
                                      unit: 'µg/m³',
                                    ),
                                    WeatherTile(
                                      icon: const Icon(Icons.whatshot),
                                      title: "Nitrogen Monoxide",
                                      value: aqiData.no.toString(),
                                      unit: 'ppb',
                                    ),
                                    WeatherTile(
                                      icon: const Icon(Icons.toys),
                                      title: "Nitrogen Dioxide",
                                      value: aqiData.no2.toString(),
                                      unit: 'ppb',
                                    ),
                                    WeatherTile(
                                      icon: const Icon(Icons.wb_sunny),
                                      title: "Ozone",
                                      value: aqiData.o3.toString(),
                                      unit: 'ppb',
                                    ),
                                    WeatherTile(
                                      icon: const Icon(Icons.all_inclusive),
                                      title: "Sulphur Dioxide",
                                      value: aqiData.so2.toString(),
                                      unit: 'ppb',
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

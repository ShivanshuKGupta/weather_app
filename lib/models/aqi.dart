class AirQuality {
  double? co;
  double? no;
  double? no2;
  double? o3;
  double? so2;
  double? pm2_5;
  double? pm10;
  double? nh3;
  double? aqi;
  AirQuality({
    this.co,
    this.no,
    this.no2,
    this.o3,
    this.so2,
    this.pm2_5,
    this.pm10,
    this.nh3,
    this.aqi,
  });
  factory AirQuality.fromJson(Map<String, dynamic> json) => AirQuality(
        co: json["co"] == null ? null : json["co"].toDouble(),
        no: json["no"] == null ? null : json["no"].toDouble(),
        no2: json["no2"] == null ? null : json["no2"].toDouble(),
        o3: json["o3"] == null ? null : json["o3"].toDouble(),
        so2: json["so2"] == null ? null : json["so2"].toDouble(),
        pm2_5: json["pm2_5"] == null ? null : json["pm2_5"].toDouble(),
        pm10: json["pm10"] == null ? null : json["pm10"].toDouble(),
        nh3: json["nh3"] == null ? null : json["nh3"].toDouble(),
        aqi: json["main"] == null || json["main"]["aqi"] == null
            ? null
            : json['main']["aqi"].toDouble(),
      );
}

import 'package:cuaca_kuring/models/daily_forecast_model.dart';

class WeatherModel {
  final double temperature2m;
  final int relativeHumidity2m;
  final double apparentTemperature;
  final double precipitation;
  final int weatherCode;
  final double windSpeed10m;
  final bool isDay;
  final String currentTime;
  final String timezone;
  final String timezoneAbbreviation;
  final List<DailyForecastModel> dailyForecasts;

  const WeatherModel({
    required this.temperature2m,
    required this.relativeHumidity2m,
    required this.apparentTemperature,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed10m,
    required this.isDay,
    required this.currentTime,
    required this.timezone,
    required this.timezoneAbbreviation,
    required this.dailyForecasts,
  });

  int get todayPrecipitationProbability => dailyForecasts.isNotEmpty
      ? dailyForecasts.first.precipitationProbabilityMax
      : 0;

  double? get todayTempMax =>
      dailyForecasts.isNotEmpty ? dailyForecasts.first.temperatureMax : null;

  double? get todayTempMin =>
      dailyForecasts.isNotEmpty ? dailyForecasts.first.temperatureMin : null;

  // [VIDEO] Model: parsing JSON Open-Meteo (current & daily) menjadi objek Dart
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>?;
    final daily = json['daily'] as Map<String, dynamic>?;

    if (current == null || daily == null) {
      throw const FormatException(
        'Format respons Open-Meteo tidak lengkap (field current/daily kosong).',
      );
    }

    final times = (daily['time'] as List<dynamic>? ?? []);
    final codes = (daily['weather_code'] as List<dynamic>? ?? []);
    final maxTemps = (daily['temperature_2m_max'] as List<dynamic>? ?? []);
    final minTemps = (daily['temperature_2m_min'] as List<dynamic>? ?? []);
    final precipProbs =
        (daily['precipitation_probability_max'] as List<dynamic>? ?? []);

    final forecasts = <DailyForecastModel>[];
    for (int i = 0; i < times.length; i++) {
      final parsedDate = DateTime.tryParse(times[i].toString());
      if (parsedDate == null) continue;

      forecasts.add(
        DailyForecastModel(
          date: parsedDate,
          weatherCode: i < codes.length && codes[i] != null
              ? (codes[i] as num).toInt()
              : 0,
          temperatureMax: i < maxTemps.length && maxTemps[i] != null
              ? (maxTemps[i] as num).toDouble()
              : 0.0,
          temperatureMin: i < minTemps.length && minTemps[i] != null
              ? (minTemps[i] as num).toDouble()
              : 0.0,
          precipitationProbabilityMax:
              i < precipProbs.length && precipProbs[i] != null
                  ? (precipProbs[i] as num).round()
                  : 0,
        ),
      );
    }

    return WeatherModel(
      temperature2m: (current['temperature_2m'] as num?)?.toDouble() ?? 0.0,
      relativeHumidity2m:
          (current['relative_humidity_2m'] as num?)?.round() ?? 0,
      apparentTemperature:
          (current['apparent_temperature'] as num?)?.toDouble() ?? 0.0,
      precipitation: (current['precipitation'] as num?)?.toDouble() ?? 0.0,
      weatherCode: (current['weather_code'] as num?)?.toInt() ?? 0,
      windSpeed10m: (current['wind_speed_10m'] as num?)?.toDouble() ?? 0.0,
      isDay: ((current['is_day'] as num?)?.toInt() ?? 1) == 1,
      currentTime: (current['time'] as String?) ?? '',
      timezone: (json['timezone'] as String?) ?? 'auto',
      timezoneAbbreviation: (json['timezone_abbreviation'] as String?) ?? '',
      dailyForecasts: forecasts,
    );
  }
}

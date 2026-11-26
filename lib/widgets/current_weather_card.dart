import 'package:cuaca_kuring/models/location_model.dart';
import 'package:cuaca_kuring/models/weather_model.dart';
import 'package:cuaca_kuring/utils/app_strings.dart';
import 'package:cuaca_kuring/utils/date_formatter.dart';
import 'package:cuaca_kuring/utils/weather_code_mapper.dart';
import 'package:flutter/material.dart';

class CurrentWeatherCard extends StatelessWidget {
  final LocationModel location;
  final WeatherModel weather;
  final AppLanguage language;

  const CurrentWeatherCard({
    super.key,
    required this.location,
    required this.weather,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(language);
    final visual = WeatherCodeMapper.map(
      weather.weatherCode,
      isDay: weather.isDay,
      language: language,
    );
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: visual.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: visual.gradientColors.first.withAlpha(70),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            location.name,
                            style: textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location.displaySubtitle,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withAlpha(220),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(40),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  weather.timezoneAbbreviation.isNotEmpty
                      ? weather.timezoneAbbreviation
                      : weather.timezone,
                  style: textTheme.labelMedium?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                visual.icon,
                size: 72,
                color: Colors.white,
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weather.temperature2m.toStringAsFixed(1)}°C',
                      style: textTheme.displayLarge?.copyWith(
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      visual.description,
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      strings.feelsLike(
                        weather.apparentTemperature.toStringAsFixed(1),
                      ),
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withAlpha(225),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(32),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (weather.todayTempMin != null &&
                    weather.todayTempMax != null)
                  Text(
                    strings.minMax(
                      weather.todayTempMin!.toStringAsFixed(0),
                      weather.todayTempMax!.toStringAsFixed(0),
                    ),
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                Text(
                  strings.updatedAt(
                    DateFormatter.formatApiTime(
                      weather.currentTime,
                      language: language,
                    ),
                  ),
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.white.withAlpha(230),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

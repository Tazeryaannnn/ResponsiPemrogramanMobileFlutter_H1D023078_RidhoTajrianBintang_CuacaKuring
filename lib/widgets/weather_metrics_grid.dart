import 'package:cuaca_kuring/models/weather_model.dart';
import 'package:cuaca_kuring/utils/app_strings.dart';
import 'package:flutter/material.dart';

class WeatherMetricsGrid extends StatelessWidget {
  final WeatherModel weather;
  final AppLanguage language;

  const WeatherMetricsGrid({
    super.key,
    required this.weather,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(language);
    final metrics = [
      _MetricItem(
        label: strings.metricHumidity,
        value: '${weather.relativeHumidity2m}%',
        icon: Icons.water_drop_rounded,
        color: Colors.blue,
      ),
      _MetricItem(
        label: strings.metricWindSpeed,
        value: '${weather.windSpeed10m.toStringAsFixed(1)} ${strings.windUnit}',
        icon: Icons.air_rounded,
        color: Colors.teal,
      ),
      _MetricItem(
        label: strings.metricRainChance,
        value: '${weather.todayPrecipitationProbability}%',
        icon: Icons.umbrella_rounded,
        color: Colors.indigo,
      ),
      _MetricItem(
        label: strings.metricPrecipitation,
        value: '${weather.precipitation.toStringAsFixed(1)} mm',
        icon: Icons.grain_rounded,
        color: Colors.cyan,
      ),
      _MetricItem(
        label: strings.metricFeelsLike,
        value: '${weather.apparentTemperature.toStringAsFixed(1)}°C',
        icon: Icons.thermostat_rounded,
        color: Colors.deepOrange,
      ),
      _MetricItem(
        label: strings.metricWeatherCode,
        value: strings.weatherCodeValue(weather.weatherCode),
        icon: Icons.tag_rounded,
        color: Colors.purple,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 600 ? 3 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: metrics.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: constraints.maxWidth >= 600 ? 2.2 : 1.75,
          ),
          itemBuilder: (context, index) => _MetricCard(item: metrics[index]),
        );
      },
    );
  }
}

class _MetricItem {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class _MetricCard extends StatelessWidget {
  final _MetricItem item;

  const _MetricCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(120)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: item.color.withAlpha(28),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, size: 18, color: item.color),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.label,
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            item.value,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

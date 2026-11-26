import 'package:cuaca_kuring/models/daily_forecast_model.dart';
import 'package:cuaca_kuring/utils/app_strings.dart';
import 'package:cuaca_kuring/utils/date_formatter.dart';
import 'package:cuaca_kuring/utils/weather_code_mapper.dart';
import 'package:flutter/material.dart';

class DailyForecastCard extends StatelessWidget {
  final List<DailyForecastModel> forecasts;
  final AppLanguage language;

  const DailyForecastCard({
    super.key,
    required this.forecasts,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(language);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(120)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_month_rounded,
                size: 20,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                strings.forecastTitle(forecasts.length),
                style: textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: forecasts.length,
            separatorBuilder: (_, __) => Divider(
              height: 16,
              color: colorScheme.outlineVariant.withAlpha(110),
            ),
            itemBuilder: (context, index) {
              final day = forecasts[index];
              final visual = WeatherCodeMapper.map(
                day.weatherCode,
                language: language,
              );
              return Row(
                children: [
                  SizedBox(
                    width: 86,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormatter.formatDayLabel(
                            day.date,
                            isToday: index == 0,
                            language: language,
                          ),
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          DateFormatter.formatShortDate(
                            day.date,
                            language: language,
                          ),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    visual.icon,
                    size: 24,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          visual.description,
                          style: textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.water_drop_outlined,
                              size: 13,
                              color: Colors.blue.shade600,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              strings.rainPercent(
                                day.precipitationProbabilityMax,
                              ),
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${day.temperatureMax.toStringAsFixed(0)}°C',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${day.temperatureMin.toStringAsFixed(0)}°C',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:cuaca_kuring/utils/app_strings.dart';
import 'package:flutter/material.dart';

class WeatherVisualInfo {
  final String description;
  final IconData icon;
  final List<Color> gradientColors;

  const WeatherVisualInfo({
    required this.description,
    required this.icon,
    required this.gradientColors,
  });
}

class WeatherCodeMapper {
  WeatherCodeMapper._();

  static WeatherVisualInfo map(
    int code, {
    bool isDay = true,
    AppLanguage language = AppLanguage.id,
  }) {
    final description = AppStrings(language).weatherDescription(code);

    switch (code) {
      case 0:
        return WeatherVisualInfo(
          description: description,
          icon: isDay ? Icons.wb_sunny_rounded : Icons.nights_stay_rounded,
          gradientColors: isDay
              ? const [Color(0xFF1E88E5), Color(0xFF42A5F5)]
              : const [Color(0xFF1A237E), Color(0xFF3949AB)],
        );
      case 1:
        return WeatherVisualInfo(
          description: description,
          icon: isDay ? Icons.wb_sunny_outlined : Icons.nights_stay_outlined,
          gradientColors: isDay
              ? const [Color(0xFF1976D2), Color(0xFF64B5F6)]
              : const [Color(0xFF1E293B), Color(0xFF334155)],
        );
      case 2:
        return WeatherVisualInfo(
          description: description,
          icon: Icons.cloud_queue_rounded,
          gradientColors: isDay
              ? const [Color(0xFF2962FF), Color(0xFF5C6BC0)]
              : const [Color(0xFF1E293B), Color(0xFF475569)],
        );
      case 3:
        return WeatherVisualInfo(
          description: description,
          icon: Icons.cloud_rounded,
          gradientColors: const [Color(0xFF455A64), Color(0xFF78909C)],
        );
      case 45:
      case 48:
        return WeatherVisualInfo(
          description: description,
          icon: Icons.foggy,
          gradientColors: const [Color(0xFF546E7A), Color(0xFF90A4AE)],
        );
      case 51:
      case 53:
      case 55:
        return WeatherVisualInfo(
          description: description,
          icon: Icons.grain_rounded,
          gradientColors: const [Color(0xFF283593), Color(0xFF5C6BC0)],
        );
      case 56:
      case 57:
        return WeatherVisualInfo(
          description: description,
          icon: Icons.ac_unit_rounded,
          gradientColors: const [Color(0xFF006064), Color(0xFF4DD0E1)],
        );
      case 61:
        return WeatherVisualInfo(
          description: description,
          icon: Icons.water_drop_outlined,
          gradientColors: const [Color(0xFF1565C0), Color(0xFF455A64)],
        );
      case 63:
        return WeatherVisualInfo(
          description: description,
          icon: Icons.water_drop_rounded,
          gradientColors: const [Color(0xFF0D47A1), Color(0xFF37474F)],
        );
      case 65:
        return WeatherVisualInfo(
          description: description,
          icon: Icons.thunderstorm_outlined,
          gradientColors: const [Color(0xFF0D47A1), Color(0xFF263238)],
        );
      case 66:
      case 67:
        return WeatherVisualInfo(
          description: description,
          icon: Icons.ac_unit_rounded,
          gradientColors: const [Color(0xFF01579B), Color(0xFF4FC3F7)],
        );
      case 71:
      case 73:
      case 75:
      case 77:
        return WeatherVisualInfo(
          description: description,
          icon: Icons.cloudy_snowing,
          gradientColors: const [Color(0xFF37474F), Color(0xFF90A4AE)],
        );
      case 80:
      case 81:
      case 82:
        return WeatherVisualInfo(
          description: description,
          icon: Icons.umbrella_rounded,
          gradientColors: const [Color(0xFF1A237E), Color(0xFF3F51B5)],
        );
      case 85:
      case 86:
        return WeatherVisualInfo(
          description: description,
          icon: Icons.cloudy_snowing,
          gradientColors: const [Color(0xFF263238), Color(0xFF78909C)],
        );
      case 95:
        return WeatherVisualInfo(
          description: description,
          icon: Icons.thunderstorm_rounded,
          gradientColors: const [Color(0xFF212121), Color(0xFF4527A0)],
        );
      case 96:
      case 99:
        return WeatherVisualInfo(
          description: description,
          icon: Icons.bolt_rounded,
          gradientColors: const [Color(0xFF1A1A2E), Color(0xFF311B92)],
        );
      default:
        return WeatherVisualInfo(
          description: description,
          icon: Icons.help_outline_rounded,
          gradientColors: const [Color(0xFF37474F), Color(0xFF607D8B)],
        );
    }
  }
}

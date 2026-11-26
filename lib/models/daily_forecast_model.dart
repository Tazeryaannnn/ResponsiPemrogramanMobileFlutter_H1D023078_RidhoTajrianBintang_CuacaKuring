class DailyForecastModel {
  final DateTime date;
  final int weatherCode;
  final double temperatureMax;
  final double temperatureMin;
  final int precipitationProbabilityMax;

  const DailyForecastModel({
    required this.date,
    required this.weatherCode,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.precipitationProbabilityMax,
  });
}

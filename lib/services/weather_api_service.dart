import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cuaca_kuring/models/location_model.dart';
import 'package:cuaca_kuring/models/weather_model.dart';
import 'package:cuaca_kuring/services/api_exception.dart';
import 'package:http/http.dart' as http;

class WeatherApiService {
  static const String _forecastHost = 'api.open-meteo.com';
  static const String _geocodingHost = 'geocoding-api.open-meteo.com';
  static const Duration _timeout = Duration(seconds: 15);

  final http.Client _client;

  WeatherApiService({http.Client? client}) : _client = client ?? http.Client();

  // [VIDEO] HTTP GET ke Open-Meteo Weather Forecast API (current, daily, timezone=auto)
  Future<WeatherModel> fetchWeather({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.https(_forecastHost, '/v1/forecast', {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'current':
          'temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m,is_day',
      'daily':
          'weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max',
      'timezone': 'auto',
      'forecast_days': '7',
    });

    final decoded = await _getJson(uri);
    return WeatherModel.fromJson(decoded);
  }

  // [VIDEO] HTTP GET ke Open-Meteo Geocoding API untuk pencarian kota real-time
  Future<List<LocationModel>> searchLocations(
    String query, {
    String languageCode = 'id',
  }) async {
    final trimmed = query.trim();
    if (trimmed.length < 2) {
      return [];
    }

    final uri = Uri.https(_geocodingHost, '/v1/search', {
      'name': trimmed,
      'count': '10',
      'language': languageCode,
      'format': 'json',
    });

    final decoded = await _getJson(uri);
    final results = decoded['results'] as List<dynamic>?;
    if (results == null || results.isEmpty) {
      return [];
    }

    return results
        .whereType<Map<String, dynamic>>()
        .map(LocationModel.fromGeocodingJson)
        .toList();
  }

  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    try {
      final response = await _client.get(uri).timeout(_timeout);
      return _processResponse(response);
    } on SocketException {
      throw const NoInternetException();
    } on TimeoutException {
      throw const RequestTimeoutException();
    } on FormatException {
      throw const ServerException('Gagal membaca format data dari server.');
    }
  }

  Map<String, dynamic> _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        final decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
        throw const ServerException('Format respons JSON tidak dikenali.');
      case 400:
        throw const BadRequestException('Parameter pencarian tidak valid.');
      case 404:
        throw const ServerException('Endpoint API tidak ditemukan.');
      case 500:
      case 502:
      case 503:
        throw const ServerException(
          'Server Open-Meteo sedang sibuk. Coba beberapa saat lagi.',
        );
      default:
        throw ServerException(
          'Gagal memuat data (Kode HTTP: ${response.statusCode}).',
        );
    }
  }
}

import 'package:cuaca_kuring/models/location_model.dart';
import 'package:cuaca_kuring/models/weather_model.dart';
import 'package:cuaca_kuring/services/api_exception.dart';
import 'package:cuaca_kuring/services/local_storage_service.dart';
import 'package:cuaca_kuring/services/weather_api_service.dart';
import 'package:cuaca_kuring/utils/app_strings.dart';
import 'package:flutter/material.dart';

enum WeatherStatus { initial, loading, loaded, empty, error }

// [VIDEO] ViewModel (MVVM): kelola state cuaca (loading, loaded, empty, error), tema, dan pilihan bahasa
class WeatherViewModel extends ChangeNotifier {
  final WeatherApiService _apiService;
  final LocalStorageService _storageService;

  WeatherViewModel({
    required WeatherApiService apiService,
    required LocalStorageService storageService,
  })  : _apiService = apiService,
        _storageService = storageService;

  WeatherStatus _status = WeatherStatus.initial;
  LocationModel _selectedLocation = LocationModel.defaultLocation;
  WeatherModel? _weather;
  String? _errorMessage;
  bool _isDarkMode = false;
  AppLanguage _language = AppLanguage.id;

  WeatherStatus get status => _status;
  LocationModel get selectedLocation => _selectedLocation;
  WeatherModel? get weather => _weather;
  String? get errorMessage => _errorMessage;
  bool get isDarkMode => _isDarkMode;
  AppLanguage get language => _language;
  AppStrings get strings => AppStrings(_language);

  Future<void> initialize() async {
    _isDarkMode = await _storageService.getIsDarkMode();
    final savedLang = await _storageService.getLanguageCode();
    _language = AppLanguage.fromCode(savedLang);
    final savedLocation = await _storageService.getLastSelectedLocation();
    if (savedLocation != null) {
      _selectedLocation = savedLocation;
    }
    notifyListeners();
    await fetchWeather();
  }

  Future<void> selectLocation(LocationModel location) async {
    _selectedLocation = location;
    await _storageService.saveLastSelectedLocation(location);
    await fetchWeather();
  }

  Future<void> fetchWeather() async {
    _status = WeatherStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _apiService.fetchWeather(
        latitude: _selectedLocation.latitude,
        longitude: _selectedLocation.longitude,
      );

      if (result.dailyForecasts.isEmpty) {
        _weather = null;
        _status = WeatherStatus.empty;
      } else {
        _weather = result;
        _status = WeatherStatus.loaded;
      }
    } on AppException catch (e) {
      _errorMessage = e.toString();
      _status = WeatherStatus.error;
    } catch (_) {
      _errorMessage = strings.weatherErrorFallback;
      _status = WeatherStatus.error;
    }

    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    await _storageService.saveIsDarkMode(_isDarkMode);
  }

  Future<void> setLanguage(AppLanguage newLanguage) async {
    if (_language == newLanguage) return;
    _language = newLanguage;
    notifyListeners();
    await _storageService.saveLanguageCode(newLanguage.code);
  }
}

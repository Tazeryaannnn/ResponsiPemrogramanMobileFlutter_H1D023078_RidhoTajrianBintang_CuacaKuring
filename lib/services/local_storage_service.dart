import 'dart:convert';

import 'package:cuaca_kuring/models/location_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// [VIDEO] Local Storage (SharedPreferences): simpan & muat lokasi favorit, riwayat, lokasi terakhir, tema, dan bahasa
class LocalStorageService {
  static const String _favoritesKey = 'favorite_locations';
  static const String _historyKey = 'search_history_locations';
  static const String _lastLocationKey = 'last_selected_location';
  static const String _darkModeKey = 'is_dark_mode';
  static const String _languageKey = 'app_language';

  Future<List<LocationModel>> getFavorites() async {
    return _readLocationList(_favoritesKey);
  }

  Future<void> saveFavorites(List<LocationModel> locations) async {
    await _writeLocationList(_favoritesKey, locations);
  }

  Future<List<LocationModel>> getSearchHistory() async {
    return _readLocationList(_historyKey);
  }

  Future<void> saveSearchHistory(List<LocationModel> locations) async {
    await _writeLocationList(_historyKey, locations);
  }

  Future<LocationModel?> getLastSelectedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_lastLocationKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = json.decode(raw) as Map<String, dynamic>;
      return LocationModel.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveLastSelectedLocation(LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastLocationKey, json.encode(location.toJson()));
  }

  Future<bool> getIsDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false;
  }

  Future<void> saveIsDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);
  }

  Future<String?> getLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey);
  }

  Future<void> saveLanguageCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, code);
  }

  Future<List<LocationModel>> _readLocationList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(key) ?? [];
    final items = <LocationModel>[];
    for (final raw in rawList) {
      try {
        final decoded = json.decode(raw) as Map<String, dynamic>;
        items.add(LocationModel.fromJson(decoded));
      } catch (_) {}
    }
    return items;
  }

  Future<void> _writeLocationList(
    String key,
    List<LocationModel> locations,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = locations.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList(key, encoded);
  }
}

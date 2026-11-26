import 'package:cuaca_kuring/models/location_model.dart';
import 'package:cuaca_kuring/services/api_exception.dart';
import 'package:cuaca_kuring/services/local_storage_service.dart';
import 'package:cuaca_kuring/services/weather_api_service.dart';
import 'package:flutter/material.dart';

enum SearchStatus { idle, loading, loaded, empty, error }

// [VIDEO] ViewModel (MVVM): kelola pencarian kota API, daftar favorit, dan riwayat pencarian
class LocationViewModel extends ChangeNotifier {
  static const int _maxHistoryItems = 10;

  final WeatherApiService _apiService;
  final LocalStorageService _storageService;

  LocationViewModel({
    required WeatherApiService apiService,
    required LocalStorageService storageService,
  })  : _apiService = apiService,
        _storageService = storageService;

  SearchStatus _searchStatus = SearchStatus.idle;
  List<LocationModel> _searchResults = [];
  List<LocationModel> _favorites = [];
  List<LocationModel> _searchHistory = [];
  String? _errorMessage;
  String _lastQuery = '';

  SearchStatus get searchStatus => _searchStatus;
  List<LocationModel> get searchResults => List.unmodifiable(_searchResults);
  List<LocationModel> get favorites => List.unmodifiable(_favorites);
  List<LocationModel> get searchHistory => List.unmodifiable(_searchHistory);
  String? get errorMessage => _errorMessage;
  String get lastQuery => _lastQuery;

  Future<void> initialize() async {
    _favorites = await _storageService.getFavorites();
    _searchHistory = await _storageService.getSearchHistory();
    notifyListeners();
  }

  Future<void> searchCities(
    String query, {
    String languageCode = 'id',
  }) async {
    final trimmed = query.trim();
    _lastQuery = trimmed;

    if (trimmed.isEmpty) {
      clearSearch();
      return;
    }

    if (trimmed.length < 2) {
      _searchResults = [];
      _errorMessage = null;
      _searchStatus = SearchStatus.idle;
      notifyListeners();
      return;
    }

    _searchStatus = SearchStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await _apiService.searchLocations(
        trimmed,
        languageCode: languageCode,
      );
      _searchResults = results;
      _searchStatus =
          results.isEmpty ? SearchStatus.empty : SearchStatus.loaded;
    } on AppException catch (e) {
      _searchResults = [];
      _errorMessage = e.toString();
      _searchStatus = SearchStatus.error;
    } catch (_) {
      _searchResults = [];
      _errorMessage = 'Gagal mencari lokasi. Silakan coba lagi.';
      _searchStatus = SearchStatus.error;
    }

    notifyListeners();
  }

  void clearSearch() {
    _lastQuery = '';
    _searchResults = [];
    _errorMessage = null;
    _searchStatus = SearchStatus.idle;
    notifyListeners();
  }

  bool isFavorite(LocationModel location) {
    return _favorites.any((item) => item.id == location.id);
  }

  Future<bool> toggleFavorite(LocationModel location) async {
    final exists = isFavorite(location);
    if (exists) {
      _favorites = _favorites.where((item) => item.id != location.id).toList();
    } else {
      _favorites = [location, ..._favorites];
    }
    notifyListeners();
    await _storageService.saveFavorites(_favorites);
    return !exists;
  }

  Future<void> addToHistory(LocationModel location) async {
    final filtered =
        _searchHistory.where((item) => item.id != location.id).toList();
    _searchHistory = [location, ...filtered].take(_maxHistoryItems).toList();
    notifyListeners();
    await _storageService.saveSearchHistory(_searchHistory);
  }

  Future<void> removeFromHistory(LocationModel location) async {
    _searchHistory =
        _searchHistory.where((item) => item.id != location.id).toList();
    notifyListeners();
    await _storageService.saveSearchHistory(_searchHistory);
  }

  Future<void> clearHistory() async {
    _searchHistory = [];
    notifyListeners();
    await _storageService.saveSearchHistory(_searchHistory);
  }
}

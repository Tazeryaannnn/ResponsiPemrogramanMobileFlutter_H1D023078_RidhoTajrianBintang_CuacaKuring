import 'dart:async';

import 'package:cuaca_kuring/models/location_model.dart';
import 'package:cuaca_kuring/utils/app_strings.dart';
import 'package:cuaca_kuring/viewmodels/location_viewmodel.dart';
import 'package:cuaca_kuring/viewmodels/weather_viewmodel.dart';
import 'package:cuaca_kuring/widgets/location_tile.dart';
import 'package:cuaca_kuring/widgets/state_feedback_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// [VIDEO] Screen 2 (Search / Location Screen): cari kota via API, pilih lokasi, simpan favorit & riwayat
class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({super.key});

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    setState(() {});
    _debounce = Timer(const Duration(milliseconds: 450), () {
      if (!mounted) return;
      final langCode =
          context.read<WeatherViewModel>().language.geocodingLanguage;
      context
          .read<LocationViewModel>()
          .searchCities(value, languageCode: langCode);
    });
  }

  void _submitSearch() {
    _debounce?.cancel();
    final langCode =
        context.read<WeatherViewModel>().language.geocodingLanguage;
    context
        .read<LocationViewModel>()
        .searchCities(_searchController.text, languageCode: langCode);
  }

  Future<void> _selectLocation(LocationModel location) async {
    final locationVm = context.read<LocationViewModel>();
    await locationVm.addToHistory(location);
    locationVm.clearSearch();
    if (!mounted) return;
    Navigator.pop(context, location);
  }

  @override
  Widget build(BuildContext context) {
    final locationVm = context.watch<LocationViewModel>();
    final weatherVm = context.watch<WeatherViewModel>();
    final language = weatherVm.language;
    final strings = weatherVm.strings;
    final hasQuery = _searchController.text.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.searchLocationTitle),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          textInputAction: TextInputAction.search,
                          onChanged: _onQueryChanged,
                          onSubmitted: (_) => _submitSearch(),
                          decoration: InputDecoration(
                            hintText: strings.searchHint,
                            prefixIcon: const Icon(Icons.search_rounded),
                            suffixIcon: hasQuery
                                ? IconButton(
                                    tooltip: strings.clearSearchTooltip,
                                    icon: const Icon(Icons.close_rounded),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {});
                                      locationVm.clearSearch();
                                    },
                                  )
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _submitSearch,
                        child: Text(strings.searchButton),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: hasQuery
                      ? _buildSearchResults(context, locationVm, language)
                      : _buildSavedLocations(context, locationVm, language),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(
    BuildContext context,
    LocationViewModel locationVm,
    AppLanguage language,
  ) {
    final strings = AppStrings(language);

    switch (locationVm.searchStatus) {
      case SearchStatus.idle:
        return StateFeedbackWidget(
          icon: Icons.travel_explore_rounded,
          title: strings.minCharsTitle,
          message: strings.minCharsMessage,
        );

      case SearchStatus.loading:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 14),
              Text(strings.loadingSearch),
            ],
          ),
        );

      case SearchStatus.error:
        return StateFeedbackWidget(
          icon: Icons.wifi_off_rounded,
          iconColor: Theme.of(context).colorScheme.error,
          title: strings.searchErrorTitle,
          message: locationVm.errorMessage ?? strings.searchErrorFallback,
          actionLabel: strings.retry,
          onAction: _submitSearch,
        );

      case SearchStatus.empty:
        return StateFeedbackWidget(
          icon: Icons.location_off_rounded,
          title: strings.cityNotFoundTitle,
          message: strings.cityNotFoundMessage(locationVm.lastQuery),
        );

      case SearchStatus.loaded:
        final results = locationVm.searchResults;
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final city = results[index];
            return LocationTile(
              location: city,
              isFavorite: locationVm.isFavorite(city),
              language: language,
              onTap: () => _selectLocation(city),
              onToggleFavorite: () => locationVm.toggleFavorite(city),
            );
          },
        );
    }
  }

  Widget _buildSavedLocations(
    BuildContext context,
    LocationViewModel locationVm,
    AppLanguage language,
  ) {
    final strings = AppStrings(language);
    final favorites = locationVm.favorites;
    final history = locationVm.searchHistory;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (favorites.isEmpty && history.isEmpty) {
      return StateFeedbackWidget(
        icon: Icons.explore_outlined,
        title: strings.startSearchTitle,
        message: strings.startSearchMessage,
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        if (favorites.isNotEmpty) ...[
          Row(
            children: [
              Icon(Icons.star_rounded, size: 20, color: Colors.amber.shade700),
              const SizedBox(width: 6),
              Text(strings.favoritesTitle, style: textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 10),
          ...favorites.map(
            (city) => LocationTile(
              location: city,
              isFavorite: true,
              language: language,
              onTap: () => _selectLocation(city),
              onToggleFavorite: () => locationVm.toggleFavorite(city),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (history.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(strings.searchHistoryTitle, style: textTheme.titleMedium),
                ],
              ),
              TextButton(
                onPressed: locationVm.clearHistory,
                child: Text(strings.clearAll),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ...history.map(
            (city) => LocationTile(
              location: city,
              isFavorite: locationVm.isFavorite(city),
              language: language,
              onTap: () => _selectLocation(city),
              onToggleFavorite: () => locationVm.toggleFavorite(city),
              onRemoveHistory: () => locationVm.removeFromHistory(city),
            ),
          ),
        ],
      ],
    );
  }
}

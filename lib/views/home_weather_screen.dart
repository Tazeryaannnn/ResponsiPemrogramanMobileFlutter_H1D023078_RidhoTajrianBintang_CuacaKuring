import 'package:cuaca_kuring/models/location_model.dart';
import 'package:cuaca_kuring/utils/app_strings.dart';
import 'package:cuaca_kuring/viewmodels/location_viewmodel.dart';
import 'package:cuaca_kuring/viewmodels/weather_viewmodel.dart';
import 'package:cuaca_kuring/views/search_location_screen.dart';
import 'package:cuaca_kuring/widgets/current_weather_card.dart';
import 'package:cuaca_kuring/widgets/daily_forecast_card.dart';
import 'package:cuaca_kuring/widgets/state_feedback_widget.dart';
import 'package:cuaca_kuring/widgets/weather_metrics_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// [VIDEO] Screen 1 (Home / Weather Screen): tampilkan cuaca terkini, detail metrik, prakiraan 7 hari, ganti bahasa & Drawer favorit
class HomeWeatherScreen extends StatefulWidget {
  const HomeWeatherScreen({super.key});

  @override
  State<HomeWeatherScreen> createState() => _HomeWeatherScreenState();
}

class _HomeWeatherScreenState extends State<HomeWeatherScreen> {
  Future<void> _openSearchScreen() async {
    final selected = await Navigator.push<LocationModel>(
      context,
      MaterialPageRoute(
        builder: (_) => const SearchLocationScreen(),
      ),
    );

    if (selected != null && mounted) {
      await context.read<WeatherViewModel>().selectLocation(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherVm = context.watch<WeatherViewModel>();
    final locationVm = context.watch<LocationViewModel>();
    final strings = weatherVm.strings;
    final currentCity = weatherVm.selectedLocation;
    final isFav = locationVm.isFavorite(currentCity);

    return Scaffold(
      appBar: AppBar(
        title: Text(currentCity.name),
        actions: [
          PopupMenuButton<AppLanguage>(
            tooltip: strings.selectLanguageTooltip,
            icon: const Icon(Icons.language_rounded),
            initialValue: weatherVm.language,
            onSelected: weatherVm.setLanguage,
            itemBuilder: (context) => AppLanguage.values
                .map(
                  (lang) => PopupMenuItem<AppLanguage>(
                    value: lang,
                    child: Row(
                      children: [
                        Icon(
                          weatherVm.language == lang
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          size: 18,
                          color: weatherVm.language == lang
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Text(lang.label),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          IconButton(
            tooltip: isFav
                ? strings.removeFavoriteTooltip
                : strings.addFavoriteTooltip,
            icon: Icon(
              isFav ? Icons.star_rounded : Icons.star_border_rounded,
              color: isFav ? Colors.amber.shade700 : null,
            ),
            onPressed: () async {
              final added = await locationVm.toggleFavorite(currentCity);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    added
                        ? strings.savedToFavorites(currentCity.name)
                        : strings.removedFromFavorites(currentCity.name),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          IconButton(
            tooltip: strings.searchLocationTitle,
            icon: const Icon(Icons.search_rounded),
            onPressed: _openSearchScreen,
          ),
        ],
      ),
      drawer: _buildDrawer(context, weatherVm, locationVm),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: weatherVm.fetchWeather,
          child: _buildBody(context, weatherVm),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openSearchScreen,
        icon: const Icon(Icons.search_rounded),
        label: Text(strings.searchCityButton),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WeatherViewModel weatherVm) {
    final strings = weatherVm.strings;

    switch (weatherVm.status) {
      case WeatherStatus.initial:
      case WeatherStatus.loading:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 14),
              Text(strings.loadingWeather),
            ],
          ),
        );

      case WeatherStatus.error:
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              child: StateFeedbackWidget(
                icon: Icons.cloud_off_rounded,
                iconColor: Theme.of(context).colorScheme.error,
                title: strings.weatherErrorTitle,
                message: weatherVm.errorMessage ?? strings.weatherErrorFallback,
                actionLabel: strings.retry,
                onAction: weatherVm.fetchWeather,
              ),
            ),
          ],
        );

      case WeatherStatus.empty:
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              child: StateFeedbackWidget(
                icon: Icons.inbox_outlined,
                title: strings.weatherEmptyTitle,
                message: strings.weatherEmptyMessage,
                actionLabel: strings.reload,
                onAction: weatherVm.fetchWeather,
              ),
            ),
          ],
        );

      case WeatherStatus.loaded:
        final weather = weatherVm.weather!;
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 92),
              children: [
                CurrentWeatherCard(
                  location: weatherVm.selectedLocation,
                  weather: weather,
                  language: weatherVm.language,
                ),
                const SizedBox(height: 18),
                Text(
                  strings.weatherDetailsTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                WeatherMetricsGrid(
                  weather: weather,
                  language: weatherVm.language,
                ),
                const SizedBox(height: 18),
                DailyForecastCard(
                  forecasts: weather.dailyForecasts,
                  language: weatherVm.language,
                ),
              ],
            ),
          ),
        );
    }
  }

  Widget _buildDrawer(
    BuildContext context,
    WeatherViewModel weatherVm,
    LocationViewModel locationVm,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final strings = weatherVm.strings;
    final favorites = locationVm.favorites;

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: colorScheme.primaryContainer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.wb_sunny_rounded,
                    size: 36,
                    color: colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Cuaca Kuring',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    strings.appSubtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                        ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.search_rounded),
              title: Text(strings.searchAndManage),
              onTap: () {
                Navigator.pop(context);
                _openSearchScreen();
              },
            ),
            SwitchListTile(
              secondary: Icon(
                weatherVm.isDarkMode
                    ? Icons.dark_mode_rounded
                    : Icons.light_mode_rounded,
              ),
              title: Text(strings.darkMode),
              value: weatherVm.isDarkMode,
              onChanged: (_) => weatherVm.toggleTheme(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.language_rounded,
                        size: 20,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        strings.languageLabel,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: AppLanguage.values.map((lang) {
                      final selected = weatherVm.language == lang;
                      return ChoiceChip(
                        label: Text(lang.label),
                        selected: selected,
                        onSelected: (_) => weatherVm.setLanguage(lang),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
              child: Text(
                strings.favoritesWithCount(favorites.length),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
            Expanded(
              child: favorites.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        strings.emptyFavoritesDrawer,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        final city = favorites[index];
                        final isSelected =
                            city.id == weatherVm.selectedLocation.id;
                        return ListTile(
                          selected: isSelected,
                          leading: Icon(
                            Icons.star_rounded,
                            color: Colors.amber.shade700,
                          ),
                          title: Text(city.name),
                          subtitle: Text(city.displaySubtitle),
                          onTap: () {
                            Navigator.pop(context);
                            weatherVm.selectLocation(city);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

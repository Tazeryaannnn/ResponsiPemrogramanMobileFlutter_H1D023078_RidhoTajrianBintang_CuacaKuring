import 'package:cuaca_kuring/services/local_storage_service.dart';
import 'package:cuaca_kuring/services/weather_api_service.dart';
import 'package:cuaca_kuring/theme/app_theme.dart';
import 'package:cuaca_kuring/viewmodels/location_viewmodel.dart';
import 'package:cuaca_kuring/viewmodels/weather_viewmodel.dart';
import 'package:cuaca_kuring/views/home_weather_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CuacaKuringApp());
}

// [VIDEO] Entry point MVVM: menghubungkan ViewModel via MultiProvider & Material 3 Theme
class CuacaKuringApp extends StatelessWidget {
  const CuacaKuringApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = WeatherApiService();
    final storageService = LocalStorageService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeatherViewModel(
            apiService: apiService,
            storageService: storageService,
          )..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationViewModel(
            apiService: apiService,
            storageService: storageService,
          )..initialize(),
        ),
      ],
      child: Consumer<WeatherViewModel>(
        builder: (context, weatherVm, _) {
          return MaterialApp(
            title: 'Cuaca Kuring',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: weatherVm.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const HomeWeatherScreen(),
          );
        },
      ),
    );
  }
}

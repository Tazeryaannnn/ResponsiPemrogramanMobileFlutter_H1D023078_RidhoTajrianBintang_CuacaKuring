# Cuaca Kuring — Aplikasi Prakiraan Cuaca Flutter (MVVM + Open-Meteo)

Aplikasi mobile berbasis Flutter untuk menampilkan informasi cuaca terkini dan prakiraan cuaca 7 hari ke depan menggunakan **Open-Meteo REST API**, penyimpanan lokal **SharedPreferences**, manajemen state **Provider**, dan arsitektur **Model-View-ViewModel (MVVM)**.

## Fitur Utama

1. **Home / Weather Screen**
   - Menampilkan nama kota yang sedang dipilih beserta wilayah/negara dan zona waktu.
   - Menampilkan kondisi cuaca terkini (ikon dinamis & deskripsi bahasa Indonesia berdasarkan WMO `weather_code`).
   - Menampilkan suhu saat ini (`current.temperature_2m`) dan suhu yang dirasakan (`current.apparent_temperature`).
   - Menampilkan detail informasi tambahan: kelembapan udara (`current.relative_humidity_2m`), kecepatan angin (`current.wind_speed_10m`), curah hujan (`current.precipitation`), peluang hujan harian (`daily.precipitation_probability_max`), dan kode cuaca.
   - Menampilkan prakiraan cuaca 7 hari ke depan (`daily.temperature_2m_min`, `daily.temperature_2m_max`, `daily.precipitation_probability_max`, `daily.weather_code`).
   - Mendukung *pull-to-refresh*, simpan/hapus favorit langsung dari AppBar, Side Menu (`Drawer`) berisi daftar kota favorit, tombol ganti Mode Terang/Gelap, serta pilihan 3 bahasa (**Bahasa Indonesia**, **Basa Sunda**, dan **English**) yang tersimpan di `SharedPreferences`.
2. **Search / Location Screen**
   - Input pencarian kota secara *real-time* (dengan debounce) yang melakukan HTTP GET ke **Open-Meteo Geocoding API**.
   - Menampilkan daftar hasil pencarian kota beserta wilayah, negara, dan koordinat.
   - Memilih kota untuk langsung memuat data cuacanya di Home Screen.
   - Menyimpan dan menghapus lokasi favorit serta menyimpan riwayat pencarian ke Local Storage (`SharedPreferences`).
3. **Penanganan State Lengkap**
   - Menangani kondisi *loading* (`CircularProgressIndicator`), *empty state* (data kosong/kota tidak ditemukan), dan *error state* (koneksi gagal/timeout) lengkap dengan tombol **Coba Lagi**.

## Struktur Aplikasi (MVVM)

```text
lib/
├── main.dart                          # Entry point, MultiProvider, MaterialApp & Theme
├── theme/
│   └── app_theme.dart                 # Material 3 ThemeData (Light & Dark) + Typography
├── models/                            # [Model] Representasi data JSON dari API & Local Storage
│   ├── location_model.dart
│   ├── weather_model.dart
│   └── daily_forecast_model.dart
├── services/                          # [Data Layer] HTTP GET Open-Meteo & SharedPreferences
│   ├── api_exception.dart
│   ├── weather_api_service.dart
│   └── local_storage_service.dart
├── viewmodels/                        # [ViewModel] Logika bisnis & state (ChangeNotifier)
│   ├── weather_viewmodel.dart
│   └── location_viewmodel.dart
├── views/                             # [View] Halaman utama aplikasi
│   ├── home_weather_screen.dart
│   └── search_location_screen.dart
├── widgets/                           # Komponen UI reusable (StatelessWidget)
│   ├── current_weather_card.dart
│   ├── weather_metrics_grid.dart
│   ├── daily_forecast_card.dart
│   ├── location_tile.dart
│   └── state_feedback_widget.dart
└── utils/                             # Utilitas mapping kode cuaca WMO & format tanggal
    ├── weather_code_mapper.dart
    ├── date_formatter.dart
    └── app_strings.dart
```

## Penerapan Arsitektur MVVM

- **Model (`lib/models/`)**: Menyimpan struktur data murni (`WeatherModel`, `DailyForecastModel`, `LocationModel`) beserta metode `fromJson()` dan `toJson()` untuk konversi data dari Open-Meteo API dan `SharedPreferences`.
- **ViewModel (`lib/viewmodels/`)**: Menggunakan `ChangeNotifier` (`WeatherViewModel` dan `LocationViewModel`) sebagai penghubung antara `Services`/`Models` dan `Views`. ViewModel memanggil `WeatherApiService` dan `LocalStorageService`, memperbarui status (`loading`, `loaded`, `empty`, `error`), lalu memanggil `notifyListeners()` agar UI otomatis diperbarui.
- **View (`lib/views/` & `lib/widgets/`)**: Hanya bertugas menampilkan UI dan meneruskan aksi pengguna ke ViewModel melalui `Provider` (`context.watch` & `context.read`), tanpa mencampur logika HTTP/parsing di dalam widget.

## Implementasi REST API Open-Meteo

Semua data cuaca diambil langsung dari REST API Open-Meteo menggunakan package `http` dengan metode **GET** (tanpa data statis/hardcoded):

1. **Weather Forecast API**
   - Endpoint: `https://api.open-meteo.com/v1/forecast`
   - Parameter:
     - `latitude` & `longitude`: koordinat kota terpilih
     - `current`: `temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m,is_day`
     - `daily`: `weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max`
     - `timezone`: `auto`
     - `forecast_days`: `7`
2. **Geocoding API**
   - Endpoint: `https://geocoding-api.open-meteo.com/v1/search`
   - Parameter: `name`, `count=10`, `language=id`, `format=json`

## Cara Menjalankan Proyek

1. Ekstrak folder `cuaca_kuring_flutter` dan buka di VS Code / Android Studio.
2. Jika folder platform bawaan (`android/`, `ios/`, dll.) belum lengkap di perangkat Anda, jalankan sekali perintah berikut di dalam folder proyek untuk menghasilkan file konfigurasi platform Flutter secara otomatis tanpa menimpa folder `lib/`:
   ```bash
   flutter create . --project-name cuaca_kuring
   ```
   *(Pastikan `<uses-permission android:name="android.permission.INTERNET" />` tetap ada di `android/app/src/main/AndroidManifest.xml`.)*
3. Unduh semua package yang dibutuhkan:
   ```bash
   flutter pub get
   ```
4. Jalankan di emulator Android atau perangkat fisik:
   ```bash
   flutter run
   ```

## Screenshot Aplikasi

> Tambahkan hasil tangkapan layar aplikasi Anda dari emulator/HP di folder `screenshots/` lalu perbarui tautan di bawah ini sebelum pengumpulan:

| Home / Weather Screen | Search / Location Screen | Side Menu (Favorit) |
| :---: | :---: | :---: |
| ![Home Screen](screenshots/home_screen.png) | ![Search Screen](screenshots/search_screen.png) | ![Drawer Favorit](screenshots/drawer_favorites.png) |

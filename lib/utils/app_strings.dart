enum AppLanguage {
  id('id', 'Bahasa Indonesia', 'ID'),
  su('su', 'Basa Sunda', 'SU'),
  en('en', 'English', 'EN');

  final String code;
  final String label;
  final String shortLabel;

  const AppLanguage(this.code, this.label, this.shortLabel);

  static AppLanguage fromCode(String? code) {
    for (final lang in AppLanguage.values) {
      if (lang.code == code) return lang;
    }
    return AppLanguage.id;
  }

  String get geocodingLanguage => this == AppLanguage.en ? 'en' : 'id';
}

// [VIDEO] Multi-bahasa (Bahasa Indonesia, Basa Sunda, English) tersimpan di SharedPreferences
class AppStrings {
  final AppLanguage lang;

  const AppStrings(this.lang);

  String _pick(String id, String su, String en) {
    switch (lang) {
      case AppLanguage.id:
        return id;
      case AppLanguage.su:
        return su;
      case AppLanguage.en:
        return en;
    }
  }

  String get appSubtitle => _pick(
        'Prakiraan Cuaca Open-Meteo (MVVM)',
        'Prakiraan Cuaca Open-Meteo (MVVM)',
        'Open-Meteo Weather Forecast (MVVM)',
      );

  String get languageLabel => _pick('Bahasa', 'Basa', 'Language');
  String get selectLanguageTooltip =>
      _pick('Pilih bahasa', 'Pilih basa', 'Select language');
  String get darkMode => _pick('Mode Gelap', 'Mode Poék', 'Dark Mode');
  String get searchAndManage =>
      _pick('Cari & Kelola Lokasi', 'Téangan & Atur Lokasi', 'Search & Manage Locations');
  String get searchLocationTitle =>
      _pick('Cari Lokasi', 'Téangan Lokasi', 'Search Location');
  String get searchCityButton => _pick('Cari Kota', 'Téangan Kota', 'Search City');
  String get searchButton => _pick('Cari', 'Téangan', 'Search');
  String get searchHint => _pick(
        'Ketik nama kota (mis. Bandung, Tokyo)',
        'Ketik ngaran kota (conto: Bandung, Tokyo)',
        'Type city name (e.g. Bandung, Tokyo)',
      );
  String get clearSearchTooltip =>
      _pick('Bersihkan pencarian', 'Hapus panéangan', 'Clear search');

  String get addFavoriteTooltip =>
      _pick('Simpan ke favorit', 'Simpen ka karesep', 'Save to favorites');
  String get removeFavoriteTooltip =>
      _pick('Hapus dari favorit', 'Hapus tina karesep', 'Remove from favorites');
  String get removeHistoryTooltip =>
      _pick('Hapus dari riwayat', 'Hapus tina riwayat', 'Remove from history');

  String savedToFavorites(String city) => _pick(
        '$city disimpan ke lokasi favorit',
        '$city disimpen ka lokasi karesep',
        '$city saved to favorites',
      );
  String removedFromFavorites(String city) => _pick(
        '$city dihapus dari favorit',
        '$city dihapus tina karesep',
        '$city removed from favorites',
      );

  String get loadingWeather => _pick(
        'Memuat data cuaca dari Open-Meteo...',
        'Keureuyeuh ngamuat data cuaca ti Open-Meteo...',
        'Loading weather data from Open-Meteo...',
      );
  String get loadingSearch =>
      _pick('Mencari lokasi...', 'Néangan lokasi...', 'Searching locations...');
  String get retry => _pick('Coba Lagi', 'Coba Deui', 'Try Again');
  String get reload => _pick('Muat Ulang', 'Muat Deui', 'Reload');

  String get weatherErrorTitle =>
      _pick('Gagal Memuat Cuaca', 'Gagal Ngamuat Cuaca', 'Failed to Load Weather');
  String get weatherErrorFallback => _pick(
        'Tidak dapat terhubung ke server Open-Meteo.',
        'Teu bisa nyambung ka server Open-Meteo.',
        'Unable to connect to the Open-Meteo server.',
      );
  String get weatherEmptyTitle =>
      _pick('Data Cuaca Kosong', 'Data Cuaca Kosong', 'No Weather Data');
  String get weatherEmptyMessage => _pick(
        'Belum ada data prakiraan cuaca untuk lokasi yang dipilih.',
        'Can aya data prakiraan cuaca pikeun lokasi nu dipilih.',
        'No forecast data available for the selected location.',
      );

  String get weatherDetailsTitle =>
      _pick('Detail Kondisi Cuaca', 'Rincian Kaayaan Cuaca', 'Weather Details');
  String feelsLike(String temp) => _pick(
        'Terasa seperti $temp°C',
        'Karasana siga $temp°C',
        'Feels like $temp°C',
      );
  String minMax(String min, String max) => _pick(
        'Min $min° / Maks $max°',
        'Min $min° / Maks $max°',
        'Min $min° / Max $max°',
      );
  String updatedAt(String time) => _pick(
        'Update: $time',
        'Diropéa: $time',
        'Updated: $time',
      );

  String get metricHumidity => _pick('Kelembapan', 'Kalembaban', 'Humidity');
  String get metricWindSpeed =>
      _pick('Kecepatan Angin', 'Kacepetan Angin', 'Wind Speed');
  String get windUnit => _pick('km/j', 'km/jam', 'km/h');
  String get metricRainChance =>
      _pick('Peluang Hujan', 'Peluang Hujan', 'Rain Chance');
  String get metricPrecipitation =>
      _pick('Curah Hujan', 'Curah Hujan', 'Precipitation');
  String get metricFeelsLike =>
      _pick('Suhu Terasa', 'Hawa Karasana', 'Feels Like');
  String get metricWeatherCode =>
      _pick('Kode Cuaca (WMO)', 'Kode Cuaca (WMO)', 'Weather Code (WMO)');
  String weatherCodeValue(int code) => _pick(
        'Kode $code',
        'Kode $code',
        'Code $code',
      );

  String forecastTitle(int days) => _pick(
        'Prakiraan $days Hari ke Depan',
        'Prakiraan $days Poé ka Hareup',
        '$days-Day Forecast',
      );
  String rainPercent(int prob) => _pick(
        '$prob% hujan',
        '$prob% hujan',
        '$prob% rain',
      );

  String favoritesWithCount(int count) => _pick(
        'Lokasi Favorit ($count)',
        'Lokasi Karesep ($count)',
        'Favorite Locations ($count)',
      );
  String get favoritesTitle =>
      _pick('Lokasi Favorit', 'Lokasi Karesep', 'Favorite Locations');
  String get emptyFavoritesDrawer => _pick(
        'Belum ada lokasi favorit. Tekan ikon bintang untuk menyimpan kota.',
        'Can aya lokasi karesep. Pencét ikon béntang pikeun nyimpen kota.',
        'No favorite locations yet. Tap the star icon to save a city.',
      );
  String get searchHistoryTitle =>
      _pick('Riwayat Pencarian', 'Riwayat Panéangan', 'Search History');
  String get clearAll => _pick('Hapus Semua', 'Hapus Sadaya', 'Clear All');

  String get minCharsTitle => _pick(
        'Ketik Minimal 2 Karakter',
        'Ketik Minimal 2 Huruf',
        'Type at Least 2 Characters',
      );
  String get minCharsMessage => _pick(
        'Masukkan minimal 2 huruf nama kota untuk mencari melalui Open-Meteo Geocoding API.',
        'Lebetkeun minimal 2 huruf ngaran kota pikeun néangan ngaliwatan Open-Meteo Geocoding API.',
        'Enter at least 2 characters of a city name to search via Open-Meteo Geocoding API.',
      );
  String get searchErrorTitle =>
      _pick('Pencarian Gagal', 'Panéangan Gagal', 'Search Failed');
  String get searchErrorFallback => _pick(
        'Terjadi kesalahan saat menghubungi server pencarian.',
        'Aya kasalahan nalika nyambung ka server panéangan.',
        'An error occurred while contacting the search server.',
      );
  String get cityNotFoundTitle =>
      _pick('Kota Tidak Ditemukan', 'Kota Teu Kapanggih', 'City Not Found');
  String cityNotFoundMessage(String query) => _pick(
        'Tidak ada hasil untuk "$query". Coba periksa ejaan atau gunakan nama kota lain.',
        'Teu aya hasil pikeun "$query". Coba pariksa éjahan atawa paké ngaran kota séjén.',
        'No results found for "$query". Check the spelling or try another city name.',
      );
  String get startSearchTitle =>
      _pick('Mulai Cari Kota', 'Mimiti Néangan Kota', 'Start Searching Cities');
  String get startSearchMessage => _pick(
        'Cari kota di seluruh dunia untuk melihat prakiraan cuacanya. Lokasi favorit dan riwayat pencarian Anda akan tersimpan otomatis.',
        'Téangan kota di sakuliah dunya pikeun ningali prakiraan cuacana. Lokasi karesep jeung riwayat panéangan bakal disimpen otomatis.',
        'Search any city worldwide to view its forecast. Your favorites and search history are saved automatically.',
      );

  String get todayLabel => _pick('Hari Ini', 'Poé Ayeuna', 'Today');

  List<String> get dayNames {
    switch (lang) {
      case AppLanguage.id:
        return const ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
      case AppLanguage.su:
        return const ['Senén', 'Salasa', 'Rebo', 'Kemis', 'Jumaah', 'Saptu', 'Minggu'];
      case AppLanguage.en:
        return const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    }
  }

  List<String> get monthNames {
    switch (lang) {
      case AppLanguage.id:
        return const ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
      case AppLanguage.su:
        return const ['Jan', 'Péb', 'Mar', 'Apr', 'Méi', 'Jun', 'Jul', 'Agu', 'Sép', 'Okt', 'Nov', 'Dés'];
      case AppLanguage.en:
        return const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    }
  }

  String weatherDescription(int code) {
    switch (code) {
      case 0:
        return _pick('Cerah', 'Cérah', 'Clear Sky');
      case 1:
        return _pick('Sebagian Cerah', 'Sawaréh Cérah', 'Mainly Clear');
      case 2:
        return _pick('Berawan Sebagian', 'Sawaréh Méga', 'Partly Cloudy');
      case 3:
        return _pick('Mendung', 'Ceudeum', 'Overcast');
      case 45:
      case 48:
        return _pick('Berkabut', 'Halimun', 'Foggy');
      case 51:
      case 53:
      case 55:
        return _pick('Gerimis', 'Giribis', 'Drizzle');
      case 56:
      case 57:
        return _pick('Gerimis Beku', 'Giribis Tiis', 'Freezing Drizzle');
      case 61:
        return _pick('Hujan Ringan', 'Hujan Leutik', 'Light Rain');
      case 63:
        return _pick('Hujan Sedang', 'Hujan Sedeng', 'Moderate Rain');
      case 65:
        return _pick('Hujan Lebat', 'Hujan Gedé', 'Heavy Rain');
      case 66:
      case 67:
        return _pick('Hujan Beku', 'Hujan És', 'Freezing Rain');
      case 71:
      case 73:
      case 75:
      case 77:
        return _pick('Bersalju', 'Salju', 'Snowfall');
      case 80:
      case 81:
      case 82:
        return _pick('Hujan Lokal', 'Hujan Lokal', 'Rain Showers');
      case 85:
      case 86:
        return _pick('Hujan Salju', 'Hujan Salju', 'Snow Showers');
      case 95:
        return _pick('Badai Petir', 'Hujan Guludug', 'Thunderstorm');
      case 96:
      case 99:
        return _pick('Badai Petir & Es', 'Guludug & Hujan És', 'Thunderstorm & Hail');
      default:
        return _pick('Cuaca Tidak Diketahui', 'Cuaca Teu Dipikanyaho', 'Unknown Weather');
    }
  }
}

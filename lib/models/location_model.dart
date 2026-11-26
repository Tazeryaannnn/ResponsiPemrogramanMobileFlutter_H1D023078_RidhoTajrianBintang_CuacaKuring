class LocationModel {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String country;
  final String? admin1;
  final String? timezone;

  const LocationModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.country,
    this.admin1,
    this.timezone,
  });

  static const LocationModel defaultLocation = LocationModel(
    id: 1642911,
    name: 'Jakarta',
    latitude: -6.2146,
    longitude: 106.8451,
    country: 'Indonesia',
    admin1: 'Jakarta',
    timezone: 'Asia/Jakarta',
  );

  factory LocationModel.fromGeocodingJson(Map<String, dynamic> json) {
    final lat = (json['latitude'] as num).toDouble();
    final lon = (json['longitude'] as num).toDouble();
    return LocationModel(
      id: (json['id'] as num?)?.toInt() ??
          '${json['name']}_${lat.toStringAsFixed(3)}_${lon.toStringAsFixed(3)}'
              .hashCode,
      name: (json['name'] as String?) ?? 'Tidak Diketahui',
      latitude: lat,
      longitude: lon,
      country: (json['country'] as String?) ?? '',
      admin1: json['admin1'] as String?,
      timezone: json['timezone'] as String?,
    );
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      country: (json['country'] as String?) ?? '',
      admin1: json['admin1'] as String?,
      timezone: json['timezone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'admin1': admin1,
      'timezone': timezone,
    };
  }

  String get displaySubtitle {
    final parts = <String>[];
    if (admin1 != null && admin1!.trim().isNotEmpty && admin1 != name) {
      parts.add(admin1!.trim());
    }
    if (country.trim().isNotEmpty) {
      parts.add(country.trim());
    }
    return parts.isEmpty ? shortCoordinate : parts.join(', ');
  }

  String get shortCoordinate =>
      '${latitude.toStringAsFixed(2)}, ${longitude.toStringAsFixed(2)}';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class AppException implements Exception {
  final String message;
  final String prefix;

  const AppException(this.message, [this.prefix = '']);

  @override
  String toString() => prefix.isEmpty ? message : '$prefix$message';
}

class NoInternetException extends AppException {
  const NoInternetException([
    String message = 'Tidak ada koneksi internet. Periksa jaringan Anda.',
  ]) : super(message);
}

class RequestTimeoutException extends AppException {
  const RequestTimeoutException([
    String message = 'Waktu permintaan habis. Silakan coba lagi.',
  ]) : super(message);
}

class BadRequestException extends AppException {
  const BadRequestException([
    String message = 'Permintaan tidak valid.',
  ]) : super(message, 'Invalid Request: ');
}

class ServerException extends AppException {
  const ServerException([
    String message = 'Terjadi gangguan pada server Open-Meteo.',
  ]) : super(message);
}

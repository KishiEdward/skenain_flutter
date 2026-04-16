class ApiConstants {
  // Base URL
  // static const String baseUrl = 'http://10.167.76.113:8080/v1';
  static const String baseUrl = 'http://localhost:8080/v1';

  // Auth endpoints
  static const String verifyToken = '/auth/verify';

  // Product endpoints
  static const String products = '/products';

  // Timeout
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}

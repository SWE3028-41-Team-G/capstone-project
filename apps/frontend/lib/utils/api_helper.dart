class ApiHelper {
  static const String baseUrl = "https://skku-dm.site/";

  static Uri buildRequest(String endpoint,
      [Map<String, String>? queryParameters]) {
    return Uri.parse(baseUrl).replace(
      path: endpoint,
      queryParameters: queryParameters,
    );
  }
}

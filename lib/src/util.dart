/// Provides various utility functions.

/// Return a human-readable timestamp.
String timestamp(DateTime dateTime) {
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

/// Returns valid headers for Three Rings.
Map<String, String> getHeaders({required String apiKey}) =>
    {'AUTHORIZATION': 'APIKEY $apiKey'};

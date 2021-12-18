/// Provides various utility functions.
import 'constants.dart';

/// Return a human-readable timestamp.
String timestamp(DateTime dateTime) {
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

/// Returns valid headers for Three Rings.
Map<String, String> getHeaders({required String apiKey}) =>
    {'AUTHORIZATION': 'APIKEY $apiKey'};

/// Return a pretty date string.
String prettyDate(DateTime dateTime) {
  final stringBuffer = StringBuffer()
    ..write(dateTime.day.toString().padLeft(2, '0'))
    ..write('/')
    ..write(dateTime.month.toString().padLeft(2, '0'))
    ..write('/')
    ..write(dateTime.year)
    ..write(' ')
    ..write(dateTime.hour.toString().padLeft(2, '0'))
    ..write(':')
    ..write(dateTime.minute.toString().padLeft(2, '0'))
    ..write(':')
    ..write(dateTime.second.toString().padLeft(2, '0'));
  return stringBuffer.toString();
}

/// Return a number padded with 0's.
String padNumber(int n) => n.toString().padLeft(2, '0');

/// Get the URL to the image of a volunteer with the given [id].

/// The URL to the image of this volunteer.
String getImageUrl(int id) => '$baseUrl/directory/$id/photos/thumb.jpg';

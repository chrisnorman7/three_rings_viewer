/// Provides the [Preferences] class.
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'rota.dart';

part 'preferences.g.dart';

/// App preferences.
@JsonSerializable()
class Preferences {
  /// Create an instance.
  Preferences({this.apiKey, List<Rota>? ignoredRotas})
      : ignoredRotas = ignoredRotas ?? [];

  /// Create an instance from a JSON object.
  factory Preferences.fromJson(Map<String, dynamic> json) =>
      _$PreferencesFromJson(json);

  /// Load an instance from shared preferences.
  factory Preferences.fromSharedPreferences(
      SharedPreferences sharedPreferences) {
    final string = sharedPreferences.getString(_keyName);
    if (string == null) {
      return Preferences();
    }
    final json = jsonDecode(string) as Map<String, dynamic>;
    return Preferences.fromJson(json);
  }

  /// The name of the preferences key in the preferences file.
  static const _keyName = 'preferences';

  /// The API key to use.
  String? apiKey;

  /// A list of ignored shift IDs.
  final List<Rota> ignoredRotas;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$PreferencesToJson(this);

  /// Save this instance.
  Future<bool> save(SharedPreferences sharedPreferences) {
    final json = toJson();
    return sharedPreferences.setString(
        _keyName, const JsonEncoder.withIndent('  ').convert(json));
  }

  /// Returns `true` if the given [rota] should be hidden.
  bool rotaHidden(Rota rota) =>
      ignoredRotas.where((element) => element.id == rota.id).isNotEmpty;

  /// Returns `true` if the given [rota] should not be hidden.
  bool rotaUnhidden(Rota rota) =>
      ignoredRotas.where((element) => element.id == rota.id).isEmpty;
}

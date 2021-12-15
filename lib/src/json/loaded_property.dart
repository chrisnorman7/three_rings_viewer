/// Provides the [LoadedProperty] class.
import 'package:json_annotation/json_annotation.dart';

import 'loaded_volunteer.dart';

part 'loaded_property.g.dart';

/// A property loaded by a [LoadedVolunteer] instance.
@JsonSerializable()
class LoadedProperty {
  /// Create an instance.
  const LoadedProperty(
      {required this.id,
      required this.code,
      required this.name,
      required this.value});

  /// Create an instance from a JSON object.
  factory LoadedProperty.fromJson(Map<String, dynamic> json) =>
      _$LoadedPropertyFromJson(json);

  /// The ID of this property.
  final int id;

  /// The code of this property.
  final String code;

  /// The name of this property.
  final String name;

  /// The value of this property.
  final String value;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$LoadedPropertyToJson(this);
}

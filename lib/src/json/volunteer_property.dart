/// Provides the [VolunteerProperty] class.
import 'package:json_annotation/json_annotation.dart';

import 'directory_volunteer.dart';

part 'volunteer_property.g.dart';

/// A property on a [DirectoryVolunteer].
@JsonSerializable()
class VolunteerProperty {
  /// Create an instance.
  const VolunteerProperty({
    required this.id,
    required this.orgName,
    required this.value,
  });

  /// Create an instance from a JSON object.
  factory VolunteerProperty.fromJson(final Map<String, dynamic> json) =>
      _$VolunteerPropertyFromJson(json);

  /// The ID of this property.
  final int id;

  /// The name of the property.
  @JsonKey(name: 'org_name')
  final String orgName;

  /// The value of this property.
  final String? value;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$VolunteerPropertyToJson(this);
}

/// Provides the [VolunteerRole] class.
import 'package:json_annotation/json_annotation.dart';

import 'directory_volunteer.dart';

part 'volunteer_role.g.dart';

/// The role for a [DirectoryVolunteer].
@JsonSerializable()
class VolunteerRole {
  /// Create an instance.
  const VolunteerRole({
    required this.id,
    required this.name,
    required this.suffix,
  });

  /// Create an instance from a JSON object.
  factory VolunteerRole.fromJson(final Map<String, dynamic> json) =>
      _$VolunteerRoleFromJson(json);

  /// The ID of this role.
  final int id;

  /// the name of this role.
  final String name;

  /// The suffix of this role.
  final String? suffix;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$VolunteerRoleToJson(this);
}

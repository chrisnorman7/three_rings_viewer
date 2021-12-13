/// Provides the [VolunteerList] class.
import 'package:json_annotation/json_annotation.dart';

import 'directory_volunteer.dart';

part 'volunteer_list.g.dart';

/// A class which holds a list of [DirectoryVolunteer] instances.
@JsonSerializable()
class VolunteerList {
  /// Create an instance.
  const VolunteerList({required this.volunteers});

  /// Create an instance from a JSON object.
  factory VolunteerList.fromJson(Map<String, dynamic> json) =>
      _$VolunteerListFromJson(json);

  /// The volunteers in this list.
  final List<DirectoryVolunteer>? volunteers;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$VolunteerListToJson(this);
}

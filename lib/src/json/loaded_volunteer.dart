/// Provides the [LoadedVolunteer] class.
import 'package:json_annotation/json_annotation.dart';

import '../widgets/home_page.dart';
import 'directory_volunteer.dart';
import 'loaded_property.dart';
import 'volunteer_property.dart';

part 'loaded_volunteer.g.dart';

/// A volunteer that has been loaded by ID.
@JsonSerializable()
class LoadedVolunteer {
  /// Create an instance.
  const LoadedVolunteer(this.volunteer);

  /// Create an instance from a JSON object.
  factory LoadedVolunteer.fromJson(final Map<String, dynamic> json) {
    final value = <String, dynamic>{};
    for (final entry in (json['volunteer']! as Map<String, dynamic>).entries) {
      if (entry.key == 'volunteer_roles') {
        final roles = <dynamic>[];
        for (final roleJson in entry.value as List<dynamic>) {
          roles.add((roleJson as JsonType)['role']);
        }
        value['roles'] = roles;
      } else if (entry.key == 'volunteer_properties') {
        final properties = <dynamic>[];
        for (final propertyJson in entry.value as List<dynamic>) {
          final loadedProperty =
              LoadedProperty.fromJson(propertyJson as JsonType);
          final property = VolunteerProperty(
            id: loadedProperty.id,
            orgName: loadedProperty.name,
            value: loadedProperty.value,
          );
          properties
              .add(<String, JsonType>{loadedProperty.code: property.toJson()});
        }
        value['volunteer_properties'] = properties;
      } else {
        value[entry.key] = entry.value;
      }
    }
    return _$LoadedVolunteerFromJson(<String, dynamic>{'volunteer': value});
  }

  /// The volunteer that has been loaded.
  final DirectoryVolunteer volunteer;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$LoadedVolunteerToJson(this);
}

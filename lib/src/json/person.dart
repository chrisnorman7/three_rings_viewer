/// Provides the [Person] class.
import 'package:json_annotation/json_annotation.dart';

import 'directory_volunteer.dart';

part 'person.g.dart';

/// The creator or updater of a [DirectoryVolunteer].
@JsonSerializable()
class Person {
  /// Create an instance.
  const Person({required this.id, required this.name, required this.username});

  /// Create an instance from a JSON object.
  factory Person.fromJson(final Map<String, dynamic> json) =>
      _$PersonFromJson(json);

  /// The ID of this creator.
  final int id;

  /// THe name of this creator.
  final String name;

  /// The username of this person.
  final String? username;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$PersonToJson(this);
}

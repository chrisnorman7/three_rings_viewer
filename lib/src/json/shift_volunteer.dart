/// Provides the [ShiftVolunteer] class.
import 'package:json_annotation/json_annotation.dart';

part 'shift_volunteer.g.dart';

/// A volunteer on a shift.
@JsonSerializable()
class ShiftVolunteer {
  /// Create an instance.
  const ShiftVolunteer({required this.id, required this.name});

  /// Create an instance from a JSON object.
  factory ShiftVolunteer.fromJson(Map<String, dynamic> json) =>
      _$ShiftVolunteerFromJson(json);

  /// The ID of this volunteer.
  final int id;

  /// The name of this volunteer.
  final String name;

  /// The URL to the image of this volunteer.
  String get imageUrl => 'https://www.3r.org.uk/directory/$id/photos/thumb.jpg';

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$ShiftVolunteerToJson(this);
}

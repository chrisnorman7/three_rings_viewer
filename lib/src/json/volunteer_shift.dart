/// Provides the [VolunteerShift] class.
import 'package:json_annotation/json_annotation.dart';

import 'shift_volunteer.dart';

part 'volunteer_shift.g.dart';

/// A volunteer's attendance on a shift.
@JsonSerializable()
class VolunteerShift {
  /// Create an instance.
  const VolunteerShift({
    required this.id,
    required this.volunteer,
    required this.confirmedAt,
    required this.putForSwapAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create an instance from a JSON object.
  factory VolunteerShift.fromJson(final Map<String, dynamic> json) =>
      _$VolunteerShiftFromJson(json);

  /// The ID of this shift.
  final int id;

  /// The volunteer on this shift.
  final ShiftVolunteer volunteer;

  /// The time the volunteer confirmed availability for this shift.
  @JsonKey(name: 'confirmed_at')
  final DateTime? confirmedAt;

  /// The time this shift was put up for swap.
  @JsonKey(name: 'put_for_swap_at')
  final DateTime? putForSwapAt;

  /// The time the volunteer signed up for this shift.
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// The time this shift was updated.
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$VolunteerShiftToJson(this);

  /// The ID of this shift.
}

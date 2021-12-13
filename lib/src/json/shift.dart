/// Provides the [Shift] class.
import 'package:json_annotation/json_annotation.dart';

import 'rota.dart';
import 'volunteer_shift.dart';

part 'shift.g.dart';

/// A shift in a list of shifts.
@JsonSerializable()
class Shift {
  /// Create an instance.
  const Shift(
      {required this.id,
      required this.title,
      required this.start,
      required this.seconds,
      required this.minimumVolunteers,
      required this.maximumVolunteers,
      required this.closedAt,
      required this.numVolunteersSatisfying,
      required this.satisfied,
      required this.numVolunteersFilling,
      required this.full,
      required this.allDay,
      required this.createdAt,
      required this.updatedAt,
      required this.points,
      required this.rota,
      required this.volunteerShifts});

  /// Create an instance from a JSON object.
  factory Shift.fromJson(Map<String, dynamic> json) => _$ShiftFromJson(json);

  /// The ID of the shift.
  final int id;

  /// The title of the shift.
  ///
  /// Note: This value always seems to be an empty string.
  final String title;

  /// The start time of this shift.
  @JsonKey(name: 'start_datetime')
  final DateTime start;

  /// The duration in seconds.
  @JsonKey(name: 'duration')
  final int seconds;

  /// Get the duration, dart-style.
  Duration get duration => Duration(seconds: seconds);

  /// The time this shift ends.
  DateTime get end => start.add(duration);

  /// The minimum number of volunteers required to fill this shift.
  @JsonKey(name: 'minimum_volunteers')
  final int minimumVolunteers;

  /// The maximum number of volunteers who can sign up to this shift.
  @JsonKey(name: 'maximum_volunteers')
  final int maximumVolunteers;

  /// When this shift was closed.
  @JsonKey(name: 'closed_at')
  final DateTime? closedAt;

  /// The number of volunteers on this shift.
  @JsonKey(name: 'num_volunteers_satisfying')
  final int numVolunteersSatisfying;

  /// Whether or not this shift is satisfied.
  final bool satisfied;

  /// The number of volunteers filling this shift.
  @JsonKey(name: 'num_volunteers_filling')
  final int numVolunteersFilling;

  /// Whether or not this shift is full.
  final bool full;

  /// Whether or not this is an all day shift.
  @JsonKey(name: 'all_day')
  final bool allDay;

  /// The time this shift was created.
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// The time this shift was updated.
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  /// The number of points you earn for this shift.
  final int? points;

  /// The rota this shift represents.
  final Rota rota;

  /// The volunteers on this shift.
  @JsonKey(name: 'volunteer_shifts')
  final List<VolunteerShift> volunteerShifts;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$ShiftToJson(this);
}

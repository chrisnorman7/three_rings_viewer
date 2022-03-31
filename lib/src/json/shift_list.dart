/// Provides the [ShiftList] class.
import 'package:json_annotation/json_annotation.dart';

import 'shift.dart';

part 'shift_list.g.dart';

/// A class which holds a list of shifts.
@JsonSerializable()
class ShiftList {
  /// Create an instance.
  const ShiftList({required this.shifts});

  /// Create an instance from a JSON object.
  factory ShiftList.fromJson(final Map<String, dynamic> json) =>
      _$ShiftListFromJson(json);

  /// The shifts in this list.
  final List<Shift> shifts;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$ShiftListToJson(this);
}

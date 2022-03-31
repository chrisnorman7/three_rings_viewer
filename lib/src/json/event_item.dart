/// Provides the [EventItem] class.
import 'package:json_annotation/json_annotation.dart';

part 'event_item.g.dart';

/// An event from Three Rings.
@JsonSerializable()
class EventItem {
  /// Create an instance.
  const EventItem({
    required this.name,
    required this.description,
    required this.eventType,
    required this.date,
  });

  /// Create an instance from a JSON object.
  factory EventItem.fromJson(final Map<String, dynamic> json) =>
      _$EventItemFromJson(json);

  /// The name of the event.
  final String name;

  /// The description of this event.
  ///
  /// This value may be empty.
  final String description;

  /// The type of the event.
  @JsonKey(name: 'event_type')
  final String eventType;

  /// The Date or time of this event.
  final DateTime date;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$EventItemToJson(this);
}

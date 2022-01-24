/// Provides the [EventList] class.
import 'package:json_annotation/json_annotation.dart';

import 'event_item.dart';

part 'event_list.g.dart';

/// A class which holds a list of [EventItem] instances.
@JsonSerializable()
class EventList {
  /// Create an instance.
  const EventList(this.events);

  /// Create an instance from a JSON object.
  factory EventList.fromJson(Map<String, dynamic> json) =>
      _$EventListFromJson(json);

  /// The events held by this object.
  final List<EventItem> events;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$EventListToJson(this);
}

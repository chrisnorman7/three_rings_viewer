// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventItem _$EventItemFromJson(Map<String, dynamic> json) => EventItem(
      name: json['name'] as String,
      description: json['description'] as String,
      eventType: json['event_type'] as String,
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$EventItemToJson(EventItem instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'event_type': instance.eventType,
      'date': instance.date.toIso8601String(),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventList _$EventListFromJson(Map<String, dynamic> json) => EventList(
      (json['events'] as List<dynamic>)
          .map((e) => EventItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EventListToJson(EventList instance) => <String, dynamic>{
      'events': instance.events,
    };

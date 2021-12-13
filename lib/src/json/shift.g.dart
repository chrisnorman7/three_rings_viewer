// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shift _$ShiftFromJson(Map<String, dynamic> json) => Shift(
      id: json['id'] as int,
      title: json['title'] as String,
      start: DateTime.parse(json['start_datetime'] as String),
      seconds: json['duration'] as int,
      minimumVolunteers: json['minimum_volunteers'] as int,
      maximumVolunteers: json['maximum_volunteers'] as int,
      closedAt: json['closed_at'] == null
          ? null
          : DateTime.parse(json['closed_at'] as String),
      numVolunteersSatisfying: json['num_volunteers_satisfying'] as int,
      satisfied: json['satisfied'] as bool,
      numVolunteersFilling: json['num_volunteers_filling'] as int,
      full: json['full'] as bool,
      allDay: json['all_day'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      points: json['points'] as int?,
      rota: Rota.fromJson(json['rota'] as Map<String, dynamic>),
      volunteerShifts: (json['volunteer_shifts'] as List<dynamic>)
          .map((e) => VolunteerShift.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ShiftToJson(Shift instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'start_datetime': instance.start.toIso8601String(),
      'duration': instance.seconds,
      'minimum_volunteers': instance.minimumVolunteers,
      'maximum_volunteers': instance.maximumVolunteers,
      'closed_at': instance.closedAt?.toIso8601String(),
      'num_volunteers_satisfying': instance.numVolunteersSatisfying,
      'satisfied': instance.satisfied,
      'num_volunteers_filling': instance.numVolunteersFilling,
      'full': instance.full,
      'all_day': instance.allDay,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'points': instance.points,
      'rota': instance.rota,
      'volunteer_shifts': instance.volunteerShifts,
    };

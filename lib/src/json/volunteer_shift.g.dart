// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volunteer_shift.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VolunteerShift _$VolunteerShiftFromJson(Map<String, dynamic> json) =>
    VolunteerShift(
      id: json['id'] as int,
      volunteer:
          ShiftVolunteer.fromJson(json['volunteer'] as Map<String, dynamic>),
      confirmedAt: json['confirmed_at'] == null
          ? null
          : DateTime.parse(json['confirmed_at'] as String),
      putForSwapAt: json['put_for_swap_at'] == null
          ? null
          : DateTime.parse(json['put_for_swap_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$VolunteerShiftToJson(VolunteerShift instance) =>
    <String, dynamic>{
      'id': instance.id,
      'volunteer': instance.volunteer,
      'confirmed_at': instance.confirmedAt?.toIso8601String(),
      'put_for_swap_at': instance.putForSwapAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

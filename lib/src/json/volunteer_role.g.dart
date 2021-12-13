// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volunteer_role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VolunteerRole _$VolunteerRoleFromJson(Map<String, dynamic> json) =>
    VolunteerRole(
      id: json['id'] as int,
      name: json['name'] as String,
      suffix: json['suffix'] as String?,
    );

Map<String, dynamic> _$VolunteerRoleToJson(VolunteerRole instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'suffix': instance.suffix,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volunteer_property.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VolunteerProperty _$VolunteerPropertyFromJson(Map<String, dynamic> json) =>
    VolunteerProperty(
      id: json['id'] as int,
      orgName: json['org_name'] as String,
      value: json['value'] as String?,
    );

Map<String, dynamic> _$VolunteerPropertyToJson(VolunteerProperty instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_name': instance.orgName,
      'value': instance.value,
    };

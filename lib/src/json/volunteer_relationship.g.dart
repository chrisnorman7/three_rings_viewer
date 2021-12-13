// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volunteer_relationship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VolunteerRelationship _$VolunteerRelationshipFromJson(
        Map<String, dynamic> json) =>
    VolunteerRelationship(
      id: json['id'] as int,
      volunteer1Id: json['volunteer1_id'] as int,
      volunteer2Id: json['volunteer2_id'] as int,
      orgRelationshipId: json['org_relationship_id'] as int,
    );

Map<String, dynamic> _$VolunteerRelationshipToJson(
        VolunteerRelationship instance) =>
    <String, dynamic>{
      'id': instance.id,
      'volunteer1_id': instance.volunteer1Id,
      'volunteer2_id': instance.volunteer2Id,
      'org_relationship_id': instance.orgRelationshipId,
    };

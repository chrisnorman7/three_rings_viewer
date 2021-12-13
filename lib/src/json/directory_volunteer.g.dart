// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_volunteer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DirectoryVolunteer _$DirectoryVolunteerFromJson(Map<String, dynamic> json) =>
    DirectoryVolunteer(
      id: json['id'] as int,
      orgId: json['org_id'] as int,
      url: json['url'] as String,
      name: json['name'] as String,
      isSupportPerson: json['is_support_person'] as bool,
      account: Account.fromJson(json['account'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      creator: Person.fromJson(json['creator'] as Map<String, dynamic>),
      updater: Person.fromJson(json['updater'] as Map<String, dynamic>),
      roles: (json['roles'] as List<dynamic>)
          .map((e) => VolunteerRole.fromJson(e as Map<String, dynamic>))
          .toList(),
      relationships: (json['relationships'] as List<dynamic>?)
          ?.map(
              (e) => VolunteerRelationship.fromJson(e as Map<String, dynamic>))
          .toList(),
      volunteerProperties: (json['volunteer_properties'] as List<dynamic>)
          .map((e) => (e as Map<String, dynamic>).map(
                (k, e) => MapEntry(
                    k, VolunteerProperty.fromJson(e as Map<String, dynamic>)),
              ))
          .toList(),
    );

Map<String, dynamic> _$DirectoryVolunteerToJson(DirectoryVolunteer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'url': instance.url,
      'name': instance.name,
      'is_support_person': instance.isSupportPerson,
      'account': instance.account,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'creator': instance.creator,
      'updater': instance.updater,
      'roles': instance.roles,
      'relationships': instance.relationships,
      'volunteer_properties': instance.volunteerProperties,
    };

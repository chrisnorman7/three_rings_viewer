// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volunteer_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VolunteerList _$VolunteerListFromJson(Map<String, dynamic> json) =>
    VolunteerList(
      volunteers: (json['volunteers'] as List<dynamic>?)
          ?.map((e) => DirectoryVolunteer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VolunteerListToJson(VolunteerList instance) =>
    <String, dynamic>{
      'volunteers': instance.volunteers,
    };

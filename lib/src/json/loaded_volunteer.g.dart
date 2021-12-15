// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loaded_volunteer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoadedVolunteer _$LoadedVolunteerFromJson(Map<String, dynamic> json) =>
    LoadedVolunteer(
      DirectoryVolunteer.fromJson(json['volunteer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoadedVolunteerToJson(LoadedVolunteer instance) =>
    <String, dynamic>{
      'volunteer': instance.volunteer,
    };

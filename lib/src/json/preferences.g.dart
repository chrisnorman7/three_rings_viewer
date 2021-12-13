// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Preferences _$PreferencesFromJson(Map<String, dynamic> json) => Preferences(
      apiKey: json['apiKey'] as String?,
      ignoredShiftIds: (json['ignoredShiftIds'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
    );

Map<String, dynamic> _$PreferencesToJson(Preferences instance) =>
    <String, dynamic>{
      'apiKey': instance.apiKey,
      'ignoredShiftIds': instance.ignoredShiftIds,
    };

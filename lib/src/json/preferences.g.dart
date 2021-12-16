// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Preferences _$PreferencesFromJson(Map<String, dynamic> json) => Preferences(
      apiKey: json['apiKey'] as String?,
      ignoredRotas: (json['ignoredRotas'] as List<dynamic>?)
          ?.map((e) => Rota.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PreferencesToJson(Preferences instance) =>
    <String, dynamic>{
      'apiKey': instance.apiKey,
      'ignoredRotas': instance.ignoredRotas,
    };

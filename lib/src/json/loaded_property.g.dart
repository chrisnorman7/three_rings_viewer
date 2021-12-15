// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loaded_property.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoadedProperty _$LoadedPropertyFromJson(Map<String, dynamic> json) =>
    LoadedProperty(
      id: json['id'] as int,
      code: json['code'] as String,
      name: json['name'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$LoadedPropertyToJson(LoadedProperty instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'value': instance.value,
    };

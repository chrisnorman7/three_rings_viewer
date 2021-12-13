// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftList _$ShiftListFromJson(Map<String, dynamic> json) => ShiftList(
      shifts: (json['shifts'] as List<dynamic>)
          .map((e) => Shift.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ShiftListToJson(ShiftList instance) => <String, dynamic>{
      'shifts': instance.shifts,
    };

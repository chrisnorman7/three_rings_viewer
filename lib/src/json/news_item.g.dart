// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsItem _$NewsItemFromJson(Map<String, dynamic> json) => NewsItem(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      url: json['url'] as String,
      orgId: json['org_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      archivedAt: json['archived_at'] == null
          ? null
          : DateTime.parse(json['archived_at'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
      sticky: json['sticky'] as bool,
      priority: json['priority'] as String,
      creator: NewsVolunteer.fromJson(json['creator'] as Map<String, dynamic>),
      updater: NewsVolunteer.fromJson(json['updater'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NewsItemToJson(NewsItem instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'url': instance.url,
      'org_id': instance.orgId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'archived_at': instance.archivedAt?.toIso8601String(),
      'expires_at': instance.expiresAt.toIso8601String(),
      'sticky': instance.sticky,
      'priority': instance.priority,
      'creator': instance.creator,
      'updater': instance.updater,
    };

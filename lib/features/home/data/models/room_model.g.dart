// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomModel _$RoomModelFromJson(Map<String, dynamic> json) => RoomModel(
  id: json['id'] as String,
  lastMessage: json['lastMessage'] as String,
  unreadMessages: (json['unreadMessages'] as num).toInt(),
  members: (json['members'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$RoomModelToJson(RoomModel instance) => <String, dynamic>{
  'id': instance.id,
  'lastMessage': instance.lastMessage,
  'unreadMessages': instance.unreadMessages,
  'members': instance.members,
};

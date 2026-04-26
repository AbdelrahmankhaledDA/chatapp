// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
  roomId: json['roomId'] as String,
  senderId: json['senderId'] as String,
  content: json['content'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
  'roomId': instance.roomId,
  'senderId': instance.senderId,
  'content': instance.content,
  'createdAt': instance.createdAt.toIso8601String(),
};

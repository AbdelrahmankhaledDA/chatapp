import 'package:chatapp/features/auth/models/user_info_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'room_model.g.dart';

@JsonSerializable()
class RoomModel {
  final String id;
  final String lastMessage;
  final int unreadMessages;
  final List<String> members;
  UserInfoModel? otherUserInfo;

  RoomModel({
    required this.id,
    required this.lastMessage,
    required this.unreadMessages,
    required this.members,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) =>
      _$RoomModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoomModelToJson(this);
}

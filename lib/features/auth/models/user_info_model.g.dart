// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfoModel _$UserInfoModelFromJson(Map<String, dynamic> json) =>
    UserInfoModel(
      UID: json['UID'] as String,
      user_name: json['user_name'] as String,
      email: json['email'] as String,
      phone_num: json['phone_num'] as String,
      image_profile: json['image_profile'] as String?,
    );

Map<String, dynamic> _$UserInfoModelToJson(UserInfoModel instance) =>
    <String, dynamic>{
      'UID': instance.UID,
      'user_name': instance.user_name,
      'email': instance.email,
      'phone_num': instance.phone_num,
      'image_profile': instance.image_profile,
    };

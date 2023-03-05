// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wish_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishRespnse _$WishRespnseFromJson(Map<String, dynamic> json) => WishRespnse(
      message: json['message'] as String?,
      wish: (json['wish'] as List<dynamic>?)
          ?.map((e) => Wish.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WishRespnseToJson(WishRespnse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'wish': instance.wish,
    };

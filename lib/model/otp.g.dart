// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OTP _$OTPFromJson(Map<String, dynamic> json) => OTP(
      otpId: json['_id'] as String?,
      userId: json['userId'] as String?,
      otp: json['otp'] as String?,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      id: json['id'] as int? ?? 0,
    );

Map<String, dynamic> _$OTPToJson(OTP instance) => <String, dynamic>{
      'id': instance.id,
      '_id': instance.otpId,
      'userId': instance.userId,
      'otp': instance.otp,
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };

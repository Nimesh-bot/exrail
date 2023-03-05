// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Users _$UsersFromJson(Map<String, dynamic> json) => Users(
      userId: json['_id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      balance: json['balance'] as num? ?? 0,
      disciplineLevel: json['disciplineLevel'] as num? ?? 5.00,
      role: json['role'] as String? ?? 'user',
      isVerified: json['isVerified'] as bool? ?? false,
      passResetVerified: json['passResetVerified'] as bool? ?? false,
      image: json['image'] == null
          ? null
          : Image.fromJson(json['image'] as Map<String, dynamic>),
      id: json['id'] as int? ?? 0,
    );

Map<String, dynamic> _$UsersToJson(Users instance) => <String, dynamic>{
      'id': instance.id,
      '_id': instance.userId,
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'balance': instance.balance,
      'disciplineLevel': instance.disciplineLevel,
      'role': instance.role,
      'isVerified': instance.isVerified,
      'passResetVerified': instance.passResetVerified,
      'image': instance.image,
    };

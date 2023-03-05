// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wish.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Wish _$WishFromJson(Map<String, dynamic> json) => Wish(
      wishId: json['_id'] as String?,
      productName: json['productName'] as String?,
      price: json['price'] as int?,
      image: json['image'] as String?,
      userId: json['userId'] as String?,
      id: json['id'] as int? ?? 0,
    );

Map<String, dynamic> _$WishToJson(Wish instance) => <String, dynamic>{
      'id': instance.id,
      '_id': instance.wishId,
      'productName': instance.productName,
      'price': instance.price,
      'image': instance.image,
      'userId': instance.userId,
    };

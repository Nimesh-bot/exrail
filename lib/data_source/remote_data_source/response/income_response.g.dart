// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncomeResponse _$IncomeResponseFromJson(Map<String, dynamic> json) =>
    IncomeResponse(
      messsage: json['messsage'] as String?,
      income: (json['income'] as List<dynamic>?)
          ?.map((e) => Income.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$IncomeResponseToJson(IncomeResponse instance) =>
    <String, dynamic>{
      'messsage': instance.messsage,
      'income': instance.income,
    };

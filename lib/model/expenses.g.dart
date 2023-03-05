// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Expenses _$ExpensesFromJson(Map<String, dynamic> json) => Expenses(
      expenseId: json['_id'] as String?,
      food: json['food'] as int?,
      transport: json['transport'] as int?,
      expected: json['expected'] as int?,
      uncertain: json['uncertain'] as int?,
      estimated_food: json['estimated_food'] as int?,
      estimated_transport: json['estimated_transport'] as int?,
      estimated_expected: json['estimated_expected'] as int?,
      userId: json['userId'] as String?,
      year: json['year'] as int?,
      month: json['month'] as int?,
      id: json['id'] as int? ?? 0,
    );

Map<String, dynamic> _$ExpensesToJson(Expenses instance) => <String, dynamic>{
      'id': instance.id,
      '_id': instance.expenseId,
      'food': instance.food,
      'transport': instance.transport,
      'expected': instance.expected,
      'uncertain': instance.uncertain,
      'estimated_food': instance.estimated_food,
      'estimated_transport': instance.estimated_transport,
      'estimated_expected': instance.estimated_expected,
      'userId': instance.userId,
      'year': instance.year,
      'month': instance.month,
    };

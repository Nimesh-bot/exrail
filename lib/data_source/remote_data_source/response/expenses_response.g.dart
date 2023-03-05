// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenses_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpensesResponse _$ExpensesResponseFromJson(Map<String, dynamic> json) =>
    ExpensesResponse(
      message: json['message'] as String?,
      expense: (json['expense'] as List<dynamic>?)
          ?.map((e) => Expenses.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExpensesResponseToJson(ExpensesResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'expense': instance.expense,
    };

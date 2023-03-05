// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Income _$IncomeFromJson(Map<String, dynamic> json) => Income(
      incomeId: json['_id'] as String?,
      monthlySalary: json['monthlySalary'] as int?,
      estimatedSaving: json['estimatedSaving'] as int?,
      receiveDate: json['receiveDate'] as String?,
      userId: json['userId'] as String?,
      year: json['year'] as int?,
      month: json['month'] as int?,
      id: json['id'] as int? ?? 0,
    );

Map<String, dynamic> _$IncomeToJson(Income instance) => <String, dynamic>{
      'id': instance.id,
      '_id': instance.incomeId,
      'monthlySalary': instance.monthlySalary,
      'estimatedSaving': instance.estimatedSaving,
      'receiveDate': instance.receiveDate,
      'userId': instance.userId,
      'year': instance.year,
      'month': instance.month,
    };

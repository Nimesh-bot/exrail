// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:exrail/repository/income_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';

part 'income.g.dart';

@JsonSerializable()
@Entity()
class Income {
  @Id(assignable: true)
  int id;

  @Unique()
  @Index()
  @JsonKey(name: '_id', includeFromJson: true, includeToJson: false)
  String? incomeId;
  int? monthlySalary;
  int? estimatedSaving;
  String? receiveDate;
  String? userId;
  int? year;
  int? month;

  Income({
    this.incomeId,
    this.monthlySalary,
    this.estimatedSaving,
    this.receiveDate,
    this.userId,
    this.year,
    this.month,
    this.id = 0,
  });

  factory Income.fromJson(Map<String, dynamic> json) => _$IncomeFromJson(json);

  Map<String, dynamic> toJson() => _$IncomeToJson(this);

  Income copyWith({
    int? id,
    String? incomeId,
    int? monthlySalary,
    int? estimatedSaving,
    String? receiveDate,
    String? userId,
    int? year,
    int? month,
  }) {
    return Income(
      id: id ?? this.id,
      incomeId: incomeId ?? this.incomeId,
      monthlySalary: monthlySalary ?? this.monthlySalary,
      estimatedSaving: estimatedSaving ?? this.estimatedSaving,
      receiveDate: receiveDate ?? this.receiveDate,
      userId: userId ?? this.userId,
      year: year ?? this.year,
      month: month ?? this.month,
    );
  }
}

class IncomeNotifier extends StateNotifier<Income> {
  IncomeNotifier() : super(Income()) {
    getIncome();
  }

  void getIncome() async {
    final income = await IncomeRepositoryImpl().getIncome();
    state = income[0];
  }

  void updateIncome(Income income) async {
    state = state.copyWith(
      monthlySalary: income.monthlySalary,
      estimatedSaving: income.estimatedSaving,
    );
  }
}

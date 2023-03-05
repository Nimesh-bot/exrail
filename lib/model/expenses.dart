// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';

import '../repository/expenses_repository.dart';

part 'expenses.g.dart';

@JsonSerializable()
@Entity()
class Expenses {
  @Id(assignable: true)
  int id;

  @Unique()
  @Index()
  @JsonKey(name: '_id')
  String? expenseId;
  int? food;
  int? transport;
  int? expected;
  int? uncertain;
  int? estimated_food;
  int? estimated_transport;
  int? estimated_expected;
  String? userId;
  int? year;
  int? month;

  // Users(this.fullname, this.email, this.password, this.balance,
  //     {this.uid = 0, this.discipline_level = 5.0});

  Expenses({
    this.expenseId,
    this.food,
    this.transport,
    this.expected,
    this.uncertain,
    this.estimated_food,
    this.estimated_transport,
    this.estimated_expected,
    this.userId,
    this.year,
    this.month,
    this.id = 0,
  });

  factory Expenses.fromJson(Map<String, dynamic> json) =>
      _$ExpensesFromJson(json);

  Map<String, dynamic> toJson() => _$ExpensesToJson(this);

  Expenses copyWith({
    int? id,
    String? expenseId,
    int? food,
    int? transport,
    int? expected,
    int? uncertain,
    int? estimated_food,
    int? estimated_transport,
    int? estimated_expected,
    String? userId,
    int? year,
    int? month,
  }) {
    return Expenses(
      id: id ?? this.id,
      expenseId: expenseId ?? this.expenseId,
      food: food ?? this.food,
      transport: transport ?? this.transport,
      expected: expected ?? this.expected,
      uncertain: uncertain ?? this.uncertain,
      estimated_food: estimated_food ?? this.estimated_food,
      estimated_transport: estimated_transport ?? this.estimated_transport,
      estimated_expected: estimated_expected ?? this.estimated_expected,
      userId: userId ?? this.userId,
      year: year ?? this.year,
      month: month ?? this.month,
    );
  }
}

class ExpensesNotifier extends StateNotifier<Expenses> {
  ExpensesNotifier()
      : super(
          Expenses(
            expenseId: '1',
            food: 0,
            transport: 0,
            expected: 0,
            uncertain: 0,
            estimated_food: 0,
            estimated_transport: 0,
            estimated_expected: 0,
            userId: '1',
            year: DateTime.now().year,
            month: DateTime.now().month,
          ),
        ) {
    getExpenses();
  }

  void getExpenses() async {
    final expenses = await ExpensesRepositoryImpl().getCurrentExpenses();
    state = expenses[0];
  }

  void updateExpenses(Expenses expenses) {
    state = state.copyWith(
      food: state.food! + expenses.food!,
      transport: state.transport! + expenses.transport!,
      expected: state.expected! + expenses.expected!,
      uncertain: state.uncertain! + expenses.uncertain!,
    );
  }

  void updateEstimatedExpenses(Expenses expenses) {
    state = state.copyWith(
      estimated_food: expenses.estimated_food,
      estimated_transport: expenses.estimated_transport,
      estimated_expected: expenses.estimated_expected,
    );
  }
}

// future provider
final expensesFutureProvider = Provider((ref) => ExpensesRepositoryImpl());

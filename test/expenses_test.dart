import 'package:exrail/data_source/remote_data_source/expenses_data_source.dart';
import 'package:exrail/model/expenses.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Get users current expenses', () async {
    List<Expenses> expenses =
        await ExpensesRemoteDataSource().getCurrentExpenses();
    expect(expenses[0].food, 0);
  });

  test('Update daily expenses', () async {
    Expenses expenses = Expenses(
      food: 100,
      transport: 50,
      expected: 0,
      uncertain: 0,
    );
    String expensesId = '63ede1668c822694329018b8';
    int status =
        await ExpensesRemoteDataSource().updateExpenses(expenses, expensesId);
    expect(status, 1);
  });

  test('Create expenses of month', () async {
    Expenses expenses = Expenses(
      food: 0,
      transport: 0,
      expected: 0,
      uncertain: 0,
      estimated_food: 10,
      estimated_transport: 10,
      estimated_expected: 10,
    );

    bool status = await ExpensesRemoteDataSource().createExpenses(expenses);
    expect(status, true);
  });
}

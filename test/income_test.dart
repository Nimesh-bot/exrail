import 'package:exrail/data_source/remote_data_source/income_data_source.dart';
import 'package:exrail/model/income.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Update monthly income testing', () async {
    int expectedResult = 1;
    Income income = Income(
      monthlySalary: 30000,
      estimatedSaving: 10000,
    );
    int actualResult = await IncomeRemoteDataSource().updateIncome(income);
    expect(expectedResult, actualResult);
  });
}

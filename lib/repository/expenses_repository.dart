import 'package:exrail/data_source/local_data_source/expenses_data_source.dart';

import '../app/network_connectivity.dart';
import '../data_source/remote_data_source/expenses_data_source.dart';
import '../model/expenses.dart';

abstract class ExpensesRepository {
  Future<List<Expenses>> getAllExpenses();
  Future<List<Expenses>> getCurrentExpenses();
  Future<bool> createExpenses(Expenses expenses);
  Future<int> updateExpenses(Expenses expenses, String expensesId);
  Future<int> updateEstimatedExpenses(Expenses expenses, String expensesId);
}

class ExpensesRepositoryImpl extends ExpensesRepository {
  @override
  Future<List<Expenses>> getAllExpenses() async {
    return ExpensesRemoteDataSource().getAllExpenses();
  }

  @override
  Future<List<Expenses>> getCurrentExpenses() async {
    bool status = await NetworkConnectivity.isOnline();
    List<Expenses> lstExpenses = [];

    if (status) {
      lstExpenses = await ExpensesRemoteDataSource().getCurrentExpenses();
      // store data obtained from remote data source to lstExpenses
      await ExpensesDataSource().addAllExpenses(lstExpenses);
      return lstExpenses;
    } else {
      return ExpensesRemoteDataSource().getCurrentExpenses();
    }
  }

  @override
  Future<int> updateExpenses(Expenses expenses, String expensesId) {
    return ExpensesRemoteDataSource().updateExpenses(expenses, expensesId);
  }

  @override
  Future<int> updateEstimatedExpenses(Expenses expenses, String expensesId) {
    return ExpensesRemoteDataSource()
        .updateEstimatedExpenses(expenses, expensesId);
  }

  @override
  Future<bool> createExpenses(Expenses expenses) {
    return ExpensesRemoteDataSource().createExpenses(expenses);
  }
}

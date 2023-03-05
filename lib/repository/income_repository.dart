import 'package:exrail/data_source/local_data_source/income_data_source.dart';
import 'package:exrail/data_source/remote_data_source/income_data_source.dart';
import 'package:exrail/model/income.dart';

import '../app/network_connectivity.dart';

abstract class IncomeRepository {
  Future<List<Income>> getIncome();
  Future<int> updateIncome(Income income);
  Future<int> addIncome(Income income);
}

class IncomeRepositoryImpl extends IncomeRepository {
  @override
  Future<List<Income>> getIncome() async {
    bool status = await NetworkConnectivity.isOnline();
    List<Income> lstIncome = [];
    if (status) {
      lstIncome = await IncomeRemoteDataSource().getIncome();
      await IncomeDataSource().addIncome(lstIncome);
      return lstIncome;
    }
    return IncomeRemoteDataSource().getIncome();
  }

  @override
  Future<int> updateIncome(Income income) {
    return IncomeRemoteDataSource().updateIncome(income);
  }

  @override
  Future<int> addIncome(Income income) {
    return IncomeRemoteDataSource().addIncome(income);
  }
}

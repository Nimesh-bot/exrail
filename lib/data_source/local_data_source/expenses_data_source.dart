import 'package:exrail/helper/objectBox.dart';
import 'package:exrail/state/objectBox_state.dart';

import '../../model/expenses.dart';

class ExpensesDataSource {
  ObjectBoxInstance get objectBoxInstance => ObjectBoxState.objectBoxInstance!;

  Future addAllExpenses(List<Expenses> lstExpenses) async {
    try {
      return objectBoxInstance.addAllExpenses(lstExpenses);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

import '../../helper/objectBox.dart';
import '../../model/income.dart';
import '../../state/objectBox_state.dart';

class IncomeDataSource {
  ObjectBoxInstance get objectBoxInstance => ObjectBoxState.objectBoxInstance!;

  Future addIncome(List<Income> lstIncome) async {
    try {
      return objectBoxInstance.addIncome(lstIncome);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

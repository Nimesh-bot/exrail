import 'package:dio/dio.dart';
import 'package:exrail/app/constants.dart';
import 'package:exrail/data_source/remote_data_source/response/expenses_response.dart';
import 'package:exrail/helper/http_service.dart';
import 'package:exrail/model/expenses.dart';

class ExpensesRemoteDataSource {
  final Dio _httpServices = HttpServices().getDioInstance();

  Future<List<Expenses>> getAllExpenses() async {
    try {
      Response response = await _httpServices.get(
          Constant.userUpdateExpensesUrl,
          options: Options(headers: {"Authorization": Constant.token}));
      if (response.statusCode == 200) {
        ExpensesResponse expensesResponse =
            ExpensesResponse.fromJson(response.data);
        return expensesResponse.expense!;
      } else {
        return [];
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<List<Expenses>> getCurrentExpenses() async {
    try {
      Response response = await _httpServices.get(Constant.userExpensesUrl,
          options: Options(headers: {"Authorization": Constant.token}));
      if (response.statusCode == 200) {
        ExpensesResponse expensesResponse =
            ExpensesResponse.fromJson(response.data);
        return expensesResponse.expense!;
      } else {
        return [];
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<bool> createExpenses(Expenses expenses) async {
    try {
      Response response =
          await _httpServices.post(Constant.userUpdateExpensesUrl,
              data: expenses,
              options: Options(headers: {
                "Authorization": Constant.token,
              }));
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<int> updateExpenses(Expenses expenses, String expensesId) async {
    try {
      Response response =
          await _httpServices.put(Constant.userUpdateExpensesUrl + expensesId,
              data: expenses,
              options: Options(headers: {
                "Authorization": Constant.token,
              }));
      if (response.statusCode == 200) {
        return 1;
      } else {
        return 0;
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<int> updateEstimatedExpenses(
      Expenses expenses, String expensesId) async {
    try {
      Response response = await _httpServices.put(
          Constant.userUpdateEstimatedExpensesUrl + expensesId,
          data: expenses,
          options: Options(headers: {
            "Authorization": Constant.token,
          }));
      if (response.statusCode == 200) {
        return 1;
      } else {
        return 0;
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}

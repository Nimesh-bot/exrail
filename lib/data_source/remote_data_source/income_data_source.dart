import 'package:dio/dio.dart';
import 'package:exrail/app/constants.dart';
import 'package:exrail/data_source/remote_data_source/response/income_response.dart';

import '../../helper/http_service.dart';
import '../../model/income.dart';

class IncomeRemoteDataSource {
  final Dio _httpServices = HttpServices().getDioInstance();

  Future<int> addIncome(Income income) async {
    try {
      Response response =
          await _httpServices.post(Constant.userAddIncomeFirstTimeUrl,
              data: income,
              options: Options(
                headers: {"Authorization": Constant.token},
              ));
      if (response.statusCode == 200) {
        return 1;
      } else {
        return 0;
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<List<Income>> getIncome() async {
    try {
      Response response = await _httpServices.get(Constant.userIncomeUrl,
          options: Options(headers: {"Authorization": Constant.token}));
      if (response.statusCode == 200) {
        IncomeResponse incomeResponse = IncomeResponse.fromJson(response.data);
        return incomeResponse.income!;
      } else {
        return [];
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<int> updateIncome(Income income) async {
    try {
      Response response = await _httpServices.put(
        Constant.userIncomeUrl,
        data: {
          "monthlySalary": income.monthlySalary,
          "estimatedSaving": income.estimatedSaving,
        },
        options: Options(
          headers: {"Authorization": Constant.token},
        ),
      );
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

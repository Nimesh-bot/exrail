import 'package:exrail/model/income.dart';
import 'package:json_annotation/json_annotation.dart';

part 'income_response.g.dart';

@JsonSerializable()
class IncomeResponse {
  String? messsage;
  List<Income>? income;

  IncomeResponse({this.messsage, this.income});

  factory IncomeResponse.fromJson(Map<String, dynamic> json) =>
      _$IncomeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$IncomeResponseToJson(this);
}

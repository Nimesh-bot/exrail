import 'package:exrail/model/expenses.dart';
import 'package:json_annotation/json_annotation.dart';

part 'expenses_response.g.dart';

@JsonSerializable()
class ExpensesResponse {
  String? message;
  List<Expenses>? expense;

  ExpensesResponse({this.message, this.expense});

  factory ExpensesResponse.fromJson(Map<String, dynamic> json) =>
      _$ExpensesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExpensesResponseToJson(this);
}

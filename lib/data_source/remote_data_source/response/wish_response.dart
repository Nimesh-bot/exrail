import 'package:exrail/model/wish.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wish_response.g.dart';

@JsonSerializable()
class WishRespnse {
  String? message;
  List<Wish>? wish;

  WishRespnse({this.message, this.wish});

  factory WishRespnse.fromJson(Map<String, dynamic> json) =>
      _$WishRespnseFromJson(json);

  Map<String, dynamic> toJson() => _$WishRespnseToJson(this);
}

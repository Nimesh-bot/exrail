import 'package:objectbox/objectbox.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wish.g.dart';

@JsonSerializable()
@Entity()
class Wish {
  @Id(assignable: true)
  int id;

  @Unique()
  @Index()
  @JsonKey(name: '_id')
  String? wishId;
  String? productName;
  int? price;
  String? image;
  String? userId;

  Wish({
    this.wishId,
    this.productName,
    this.price,
    this.image,
    this.userId,
    this.id = 0,
  });

  factory Wish.fromJson(Map<String, dynamic> json) => _$WishFromJson(json);

  Map<String, dynamic> toJson() => _$WishToJson(this);
}

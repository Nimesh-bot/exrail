import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';

part 'otp.g.dart';

@JsonSerializable()
@Entity()
class OTP {
  @Id(assignable: true)
  int id;

  @Unique()
  @Index()
  @JsonKey(name: '_id')
  String? otpId;
  String? userId;
  String? otp;
  DateTime? expiresAt;

  OTP({
    this.otpId,
    this.userId,
    this.otp,
    this.expiresAt,
    this.id = 0,
  });

  factory OTP.fromJson(Map<String, dynamic> json) => _$OTPFromJson(json);

  Map<String, dynamic> toJson() => _$OTPToJson(this);
}

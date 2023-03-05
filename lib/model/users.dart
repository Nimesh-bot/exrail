// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:exrail/repository/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';

part 'users.g.dart';

@JsonSerializable()
@Entity()
class Users {
  @Id(assignable: true)
  int id;

  @Unique()
  @Index()
  @JsonKey(name: '_id')
  String? userId;
  String? name;
  String? email;
  String? password;
  num? balance;
  num? disciplineLevel;
  String? role;
  bool? isVerified;
  bool? passResetVerified;
  Image? image;

  Users({
    this.userId,
    this.name,
    this.email,
    this.password,
    this.balance = 0,
    this.disciplineLevel = 5.00,
    this.role = 'user',
    this.isVerified = false,
    this.passResetVerified = false,
    this.image,
    this.id = 0,
  });

  factory Users.fromJson(Map<String, dynamic> json) => _$UsersFromJson(json);

  Map<String, dynamic> toJson() => _$UsersToJson(this);

  Users copyWith({
    int? id,
    String? userId,
    String? name,
    String? email,
    String? password,
    num? balance,
    num? disciplineLevel,
    String? role,
    bool? isVerified,
    bool? passResetVerified,
    Image? image,
  }) {
    return Users(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      balance: balance ?? this.balance,
      disciplineLevel: disciplineLevel ?? this.disciplineLevel,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      passResetVerified: passResetVerified ?? this.passResetVerified,
      image: image ?? this.image,
    );
  }
}

class Image {
  String imgUrl;
  String imgKey;

  Image({this.imgUrl = "", this.imgKey = ""});

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      imgUrl: json['img_url'],
      imgKey: json['img_key'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'img_url': imgUrl,
      'img_key': imgKey,
    };
  }
}

class UserNotifier extends StateNotifier<Users> {
  UserNotifier()
      : super(
          Users(
            userId: "",
            name: "",
            email: "",
            password: "",
            balance: 0,
            disciplineLevel: 5.00,
            role: 'user',
            isVerified: false,
            passResetVerified: false,
            image: Image(
              imgUrl: "",
              imgKey: "",
            ),
          ),
        ) {
    getUserDetails();
  }

  void getUserDetails() async {
    final user = await UserRepositoryImpl().getUserDetail();
    state = user;
  }

  void updateUserImage(String imgUrl, String imgKey) async {
    state = state.copyWith(
      image: Image(
        imgUrl: imgUrl,
        imgKey: imgKey,
      ),
    );
  }

  void updateUserName(String name) async {
    state = state.copyWith(
      name: name,
    );
  }
}

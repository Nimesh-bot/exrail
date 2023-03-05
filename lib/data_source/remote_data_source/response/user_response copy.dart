class ImageResponse {
  String? img_url;
  String? img_key;

  ImageResponse({this.img_url, this.img_key});
}

class UserImageResponse {
  ImageResponse? image;

  UserImageResponse.fromJson(json);

  toJson() {}
}

class UserResponse {
  String? message;
  String? email;
  UserImageResponse? user;
  String? id;
  String? name;
  String? password;
  int? balance;
  int? discipline_level;
  String? role;

  UserResponse({
    this.message,
    this.email,
    this.user,
    this.id,
    this.name,
    this.password,
    this.balance,
    this.discipline_level,
    this.role,
  });

  UserResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    email = json['email'];
    user =
        json['user'] != null ? UserImageResponse.fromJson(json['user']) : null;
    id = json['id'];
    name = json['name'];
    password = json['password'];
    balance = json['balance'];
    discipline_level = json['discipline_level'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['email'] = email;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['id'] = id;
    data['name'] = name;
    data['password'] = password;
    data['balance'] = balance;
    data['discipline_level'] = discipline_level;
    data['role'] = role;
    return data;
  }
}

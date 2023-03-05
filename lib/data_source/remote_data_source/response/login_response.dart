class LoginResponse {
  String? message;
  String? id;
  String? access;
  String? refresh;

  LoginResponse({this.message, this.id, this.access, this.refresh});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    id = json['id'];
    access = json['access'];
    refresh = json['refresh'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['id'] = id;
    data['access'] = access;
    data['refresh'] = refresh;
    return data;
  }
}

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:exrail/app/constants.dart';
import 'package:exrail/data_source/remote_data_source/response/login_response.dart';
import 'package:exrail/data_source/remote_data_source/response/user_response.dart';
import 'package:exrail/helper/http_service.dart';
import 'package:exrail/model/users.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class UserRemoteDataSource {
  final Dio _httpServices = HttpServices().getDioInstance();

  Future<int> createUser(Users user) async {
    try {
      Response response =
          await _httpServices.post(Constant.userRegisterURL, data: {
        "name": user.name,
        "email": user.email,
        "password": user.password,
      });
      if (response.statusCode == 200) {
        return 1;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  Future<bool> loginUser(String email, String password) async {
    try {
      Response response = await _httpServices.post(
        Constant.userLoginUrl,
        data: {
          "email": email,
          "password": password,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoginResponse loginResponse = LoginResponse.fromJson(response.data);
        Constant.token = loginResponse.access!;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<Users> getUserByEmail(String email) async {
    try {
      Response response = await _httpServices.get(
        Constant.userByEmailUrl + email,
      );
      if (response.statusCode == 200) {
        UserResponse userResponse = UserResponse.fromJson(response.data);
        return userResponse.user!;
      } else {
        return Users();
      }
    } catch (e) {
      return Users();
    }
  }

  Future<int> requestPasswordReset(String email) async {
    try {
      Response response = await _httpServices.post(
        Constant.userPasswordResetUrl,
        data: {
          "email": email,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return 1;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  Future<int> verifyPasswordReset(String userId, int otp) async {
    try {
      Response response = await _httpServices.post(
        Constant.userVerifyPasswordResetUrl,
        data: {
          "user_id": userId,
          "otp": otp,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return 1;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  Future<int> changePassword(String userId, String password) async {
    try {
      Response response = await _httpServices.put(
        Constant.userUpdatePasswordUrl,
        data: {
          "userId": userId,
          "password": password,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return 1;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  Future<Users> getUserDetails() async {
    try {
      Response response = await _httpServices.get(
        Constant.userDetailUrl,
        options: Options(
          headers: {"Authorization": Constant.token},
        ),
      );
      if (response.statusCode == 200) {
        UserResponse userResponse = UserResponse.fromJson(response.data);
        return userResponse.user!;
      } else {
        return Users();
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<bool> addAdditionalIncome(int additional) async {
    try {
      Response response = await _httpServices.put(
        Constant.userAdditionalIncomeUrl,
        data: {
          "additional": additional,
        },
        options: Options(
          headers: {"Authorization": Constant.token},
        ),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<bool> updateUserImage(File? file) async {
    try {
      MultipartFile? image;
      if (file != null) {
        var mimeType = lookupMimeType(file.path);
        image = await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
          contentType: MediaType('image', mimeType!.split('/').last),
        );
      }

      FormData formData = FormData.fromMap({
        "image": image,
      });

      Response response = await _httpServices.put(
        Constant.userUpdateImageUrl,
        data: formData,
        options: Options(
          headers: {"Authorization": Constant.token},
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<bool> updateUserInfo(Users user) async {
    try {
      Response response = await _httpServices.put(
        Constant.userUpdateNameUrl,
        data: user,
        options: Options(
          headers: {"Authorization": Constant.token},
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}

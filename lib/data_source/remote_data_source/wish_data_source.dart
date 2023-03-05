import 'dart:io';

import 'package:dio/dio.dart';
import 'package:exrail/app/constants.dart';
import 'package:exrail/data_source/remote_data_source/response/wish_response.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import '../../helper/http_service.dart';
import '../../model/wish.dart';

class WishRemoteDataSource {
  final Dio _httpServices = HttpServices().getDioInstance();

  Future<List<Wish>> getWish() async {
    try {
      Response response = await _httpServices.get(Constant.userWishUrl,
          options:
              Options(headers: {"Authorization": "Bearer ${Constant.token}"}));
      if (response.statusCode == 200) {
        WishRespnse wishRespnse = WishRespnse.fromJson(response.data);
        return wishRespnse.wish!;
      } else {
        return [];
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<bool> deleteWish(String wishId) async {
    try {
      Response response = await _httpServices.delete(
          Constant.userWishUrl + wishId,
          options: Options(headers: {"Authorization": Constant.token}));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<bool> addWish(File? file, Wish wish) async {
    try {
      MultipartFile? image;
      if (file != null) {
        var mimeType = lookupMimeType(file.path);
        image = await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
          contentType: MediaType('image', mimeType!.split('/')[1]),
        );
      }

      FormData formData = FormData.fromMap({
        "productName": wish.productName,
        "price": wish.price,
        "image": image,
      });

      Response response = await _httpServices.post(
        Constant.userWishUrl,
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
}

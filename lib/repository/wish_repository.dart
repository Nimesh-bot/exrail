import 'dart:io';

import '../data_source/remote_data_source/wish_data_source.dart';
import '../model/wish.dart';

abstract class WishRepository {
  Future<List<Wish>> getWish();
  Future<bool> deleteWish(String wishId);
  Future<bool> addWish(File? file, Wish wish);
}

class WishRepositoryImpl extends WishRepository {
  @override
  Future<List<Wish>> getWish() async {
    List<Wish> lstWish = [];
    lstWish = await WishRemoteDataSource().getWish();
    return lstWish;
  }

  @override
  Future<bool> deleteWish(String wishId) async {
    return await WishRemoteDataSource().deleteWish(wishId);
  }

  @override
  Future<bool> addWish(File? file, Wish wish) {
    return WishRemoteDataSource().addWish(file, wish);
  }
}

import 'dart:io';

import 'package:exrail/app/network_connectivity.dart';
import 'package:exrail/data_source/local_data_source/users_data_source.dart';
import 'package:exrail/data_source/remote_data_source/user_data_source.dart';
import 'package:exrail/model/users.dart';

abstract class UserRepository {
  Future<int> createUser(Users user);
  Future<List<Users>> getAllUsers();
  Future<bool> loginUser(String email, String password);
  Future<int> requestPasswordReset(String email);
  Future<int> verifyPasswordReset(String userId, int otp);
  Future<int> changePassword(String userId, String password);
  Future<Users> getUserByEmail(String email);
  Future<Users> getUserDetail();
  Future<bool> addAdditionalIncome(int additional);
  Future<bool> updateUserImage(File? file);
  Future<bool> updateUserInfo(Users user);
}

class UserRepositoryImpl extends UserRepository {
  @override
  Future<int> createUser(Users user) async {
    return UserRemoteDataSource().createUser(user);
  }

  @override
  Future<List<Users>> getAllUsers() {
    return UsersDataSource().getAllUsers();
  }

  @override
  Future<bool> loginUser(String email, String password) async {
    bool status = await NetworkConnectivity.isOnline();
    if (status) {
      return UserRemoteDataSource().loginUser(email, password);
    } else {
      return UsersDataSource().loginUser(email, password);
    }
  }

  @override
  Future<int> requestPasswordReset(String email) async {
    return UserRemoteDataSource().requestPasswordReset(email);
  }

  @override
  Future<int> verifyPasswordReset(String userId, int otp) async {
    return UserRemoteDataSource().verifyPasswordReset(userId, otp);
  }

  @override
  Future<int> changePassword(String userId, String password) async {
    return UserRemoteDataSource().changePassword(userId, password);
  }

  @override
  Future<Users> getUserByEmail(String email) {
    return UserRemoteDataSource().getUserByEmail(email);
  }

  @override
  Future<Users> getUserDetail() async {
    // bool status = await NetworkConnectivity.isOnline();
    // Users user = Users();
    // if (status) {
    //   Users user = await UserRemoteDataSource().getUserDetails();
    //   print('User: ${user.toJson()}');
    //   if (user.userId != null) {
    //     await UsersDataSource().createUser(user);
    //   }
    //   return user;
    // } else {
    //   return UsersDataSource().getUserDetails();
    // }
    return UserRemoteDataSource().getUserDetails();
  }

  @override
  Future<bool> addAdditionalIncome(int additional) {
    return UserRemoteDataSource().addAdditionalIncome(additional);
  }

  @override
  Future<bool> updateUserImage(File? file) {
    return UserRemoteDataSource().updateUserImage(file);
  }

  @override
  Future<bool> updateUserInfo(Users user) {
    return UserRemoteDataSource().updateUserInfo(user);
  }
}

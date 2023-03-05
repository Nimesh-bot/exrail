import 'dart:io';

import 'package:exrail/data_source/remote_data_source/user_data_source.dart';
import 'package:exrail/model/users.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Get User by their email', () async {
    String email = 'thesunwayshow@gmail.com';
    Users user = await UserRemoteDataSource().getUserByEmail(email);
    expect(user.email, email);
  });

  test('Get user detail by token', () async {
    Users user = await UserRemoteDataSource().getUserDetails();
    expect(user.email, 'thesunwayshow@gmail.com');
  });

  test('Add additional income', () async {
    bool expectedResult = true;
    int additional = 1000;
    bool actualResult =
        await UserRemoteDataSource().addAdditionalIncome(additional);
    expect(expectedResult, actualResult);
  });

  test('Update user image', () async {
    File? img = File('assets/images/vectors/hash.png');
    bool status = await UserRemoteDataSource().updateUserImage(img);
    expect(status, true);
  });
}

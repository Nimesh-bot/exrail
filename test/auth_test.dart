import 'package:exrail/data_source/remote_data_source/user_data_source.dart';
import 'package:exrail/model/users.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('login testing', () async {
    bool expectedResult = true;
    String email = 'somit409@gmail.com';
    String password = 'Password111@';
    bool actualResult = await UserRemoteDataSource().loginUser(email, password);

    expect(expectedResult, actualResult);
  });

  test('regsiter testing', () async {
    int expectedResult = 1;
    String name = 'Sergio Beckk';
    String email = 'ss.sergios@gmail.com';
    String password = 'Password888@';

    Users user = Users(
      name: name,
      email: email,
      password: password,
    );

    int actualResult = await UserRemoteDataSource().createUser(user);

    expect(expectedResult, actualResult);
  });
}

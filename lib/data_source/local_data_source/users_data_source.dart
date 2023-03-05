import 'package:exrail/helper/objectBox.dart';
import 'package:exrail/model/users.dart';
import 'package:exrail/state/objectBox_state.dart';

class UsersDataSource {
  ObjectBoxInstance get objectBoxInstance => ObjectBoxState.objectBoxInstance!;

  Future<int> createUser(Users user) async {
    try {
      return objectBoxInstance.createUser(user);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Users>> getAllUsers() {
    try {
      return Future.value(objectBoxInstance.getAllUsers());
    } catch (e) {
      throw Exception('Error in getting all users');
    }
  }

  Future<bool> loginUser(String email, String password) async {
    try {
      if (objectBoxInstance.loginUser(email, password) != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  Future<Users> getUserDetails() async {
    try {
      return Future.value(objectBoxInstance.getUserDetail());
    } catch (e) {
      throw Future.value(Users());
    }
  }
}

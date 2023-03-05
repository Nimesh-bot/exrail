import 'dart:io';

import 'package:exrail/model/otp.dart';
import 'package:exrail/model/users.dart';
import 'package:exrail/model/wish.dart';
import 'package:exrail/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';

import '../model/expenses.dart';
import '../model/income.dart';

// var objectBoxInstance = Provider((ref)=>
//   ObjectBoxInstance()
// );
class ObjectBoxInstance {
  late final Store _store;
  late final Box<Users> _users;
  late final Box<OTP> _otp;
  late final Box<Expenses> _expenses;
  late final Box<Income> _income;
  late final Box<Wish> _wish;

  ObjectBoxInstance(this._store) {
    _users = Box<Users>(_store);
    _otp = Box<OTP>(_store);
    _expenses = Box<Expenses>(_store);
    _income = Box<Income>(_store);
    _wish = Box<Wish>(_store);
  }

  static Future<ObjectBoxInstance> init() async {
    var dir = await getApplicationDocumentsDirectory();
    final store = Store(
      getObjectBoxModel(),
      directory: '${dir.path}/exrail',
    );

    return ObjectBoxInstance(store);
  }

  // Delete Store and all boxes
  static Future<void> deleteDatabase() async {
    var dir = await getApplicationDocumentsDirectory();
    Directory('${dir.path}/exrail').deleteSync(recursive: true);
  }

  // Users
  int createUser(Users user) {
    return _users.put(user);
  }

  List<Users> getAllUsers() {
    return _users.getAll();
  }

  // get user by email
  Users? getUserByEmail(String email) {
    return _users.query(Users_.email.equals(email)).build().findFirst();
  }

  Users? getUserDetail() {
    return _users.query().build().findFirst();
  }

  Users? loginUser(String email, String password) {
    return _users
        .query(Users_.email.equals(email) & Users_.password.equals(password))
        .build()
        .findFirst();
  }

  Users? requestPasswordReset(String email) {
    return _users.query(Users_.email.equals(email)).build().findFirst();
  }

  OTP? verifyOTPforPasswordReset(String userId, String otp) {
    return _otp
        .query(OTP_.userId.equals(userId) & OTP_.otp.equals(otp))
        .build()
        .findFirst();
  }

  Users? changePassword(int id, String password) {
    Users? user = _users.query(Users_.id.equals(id)).build().findFirst();
    if (user != null) {
      user.password = password;
      _users.put(user);
    }
    return user;
  }

  // Expense
  Expenses? getRecentExpenses(String userId) {
    return _expenses.query(Expenses_.userId.equals(userId)).build().findFirst();
  }

  int addExpense(Expenses expense) {
    return _expenses.put(expense);
  }

  void addAllExpenses(List<Expenses> lstExpenses) {
    for (var item in lstExpenses) {
      if (_expenses
              .query(Expenses_.expenseId.equals(item.expenseId!))
              .build()
              .findFirst() ==
          null) {
        _expenses.put(item);
      }
    }
  }

  // Income
  void addIncome(List<Income> lstIncome) {
    for (var item in lstIncome) {
      if (_income
              .query(Income_.incomeId.equals(item.incomeId!))
              .build()
              .findFirst() ==
          null) {
        _income.put(item);
      }
    }
  }

  Income? getIncome(String userId) {
    return _income.query(Income_.userId.equals(userId)).build().findFirst();
  }

  // Wish
  Wish? getWish(String userId) {
    return _wish.query(Wish_.userId.equals(userId)).build().findFirst();
  }
}

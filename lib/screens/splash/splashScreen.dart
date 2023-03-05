import 'package:exrail/app/constants.dart';
import 'package:exrail/model/income.dart';
import 'package:exrail/repository/income_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/expenses.dart';
import '../../repository/expenses_repository.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // Future.delayed(const Duration(seconds: 2), () {
    //   Navigator.pushReplacementNamed(context, '/login');
    // });
    _checkLogin();
    super.initState();
  }

  _checkLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (token != null) {
      Constant.token = token;
      _checkIfHasExpenses();
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  _checkIfHasExpenses() async {
    List<Expenses> lstCurrentExpenses =
        await ExpensesRepositoryImpl().getCurrentExpenses();
    if (lstCurrentExpenses.isEmpty) {
      Navigator.pushReplacementNamed(context, '/checkExpensesScreen');
    } else {
      _checkIfNewUser();
    }
  }

  _checkIfNewUser() async {
    List<Income> lstIncome = await IncomeRepositoryImpl().getIncome();
    if (lstIncome.isEmpty) {
      Navigator.pushReplacementNamed(context, '/addIncomeScreen');
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/images/Logo.png'),
              height: 100,
              width: 100,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(
                  height: 14,
                  width: 14,
                  child: CircularProgressIndicator(
                    color: Colors.cyan,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Loading all the assets',
                  style: TextStyle(
                    color: Colors.cyan,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

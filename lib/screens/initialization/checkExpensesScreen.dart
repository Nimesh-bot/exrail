import 'package:exrail/app/snackbar.dart';
import 'package:exrail/model/expenses.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../repository/expenses_repository.dart';

class CheckExpensesScreen extends StatefulWidget {
  const CheckExpensesScreen({super.key});

  @override
  State<CheckExpensesScreen> createState() => _CheckExpensesScreenState();
}

class _CheckExpensesScreenState extends State<CheckExpensesScreen> {
  @override
  void initState() {
    super.initState();
    _checkIfNewUser();
    _checkIfHasExpenses();
  }

  List<Expenses> _allExpenses = [];
  bool _isLoading = false;
  bool _isChecking = true;

  _checkIfNewUser() async {
    List<Expenses> lstExpenses =
        await ExpensesRepositoryImpl().getCurrentExpenses();
    print(lstExpenses);
    setState(() {
      _allExpenses = lstExpenses;
    });
  }

  _checkIfHasExpenses() async {
    List<Expenses> lstCurrentExpenses =
        await ExpensesRepositoryImpl().getCurrentExpenses();
    print(lstCurrentExpenses);
    if (lstCurrentExpenses.isNotEmpty) {
      Navigator.pushReplacementNamed(context, '/checkIncomeScreen');
    }
    setState(() {
      _isChecking = false;
    });
  }

  _createExpenseForCurrentMonth() async {
    setState(() {
      _isLoading = true;
    });

    Expenses expenses = Expenses(
        food: 0,
        transport: 0,
        expected: 0,
        uncertain: 0,
        estimated_food: 1000,
        estimated_transport: 1000,
        estimated_expected: 1000);

    bool status = await ExpensesRepositoryImpl().createExpenses(expenses);

    _showMessage(status);
  }

  _showMessage(status) {
    setState(() {
      _isLoading = false;
    });
    if (status) {
      Navigator.pushReplacementNamed(context, '/checkIncomeScreen');
    } else {
      showSnackbar(context, 'Something went wrong', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: _isChecking
              ? SizedBox(
                  width: double.infinity,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 21,
                          height: 21,
                          child: CircularProgressIndicator(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text('Checking your expenses...',
                            style: Theme.of(context).textTheme.displaySmall),
                      ]),
                )
              : Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images/backgrounds/expenses.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // const SizedBox(
                          //   height: 60,
                          // ),
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.stretch,
                          //   children: const [
                          //     Icon(
                          //       Icons.restaurant,
                          //       color: Color(0xffeeeeee),
                          //       size: 45,
                          //     ),
                          //     SizedBox(
                          //       height: 40,
                          //     ),
                          //     Icon(Icons.train, color: Color(0xffeeeeee), size: 45),
                          //     SizedBox(
                          //       height: 40,
                          //     ),
                          //     Icon(Icons.attach_money,
                          //         color: Color(0xffeeeeee), size: 45),
                          //   ],
                          // ),
                          // add container with background image

                          const SizedBox(
                            height: 60,
                          ),
                          _allExpenses.isNotEmpty
                              ? Text(
                                  "It's a new month",
                                  style:
                                      Theme.of(context).textTheme.displayLarge,
                                )
                              : Text(
                                  "Let's start",
                                  style:
                                      Theme.of(context).textTheme.displayLarge,
                                ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            "Create your expenses jounal for ${DateFormat('MMMM').format(DateTime.now())}",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            "Note that, we will setup your expenses with 0 for now and estimated expenses with 1000. You can update your estimation later.",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_isLoading) {
                                  return;
                                } else {
                                  _createExpenseForCurrentMonth();
                                }
                              },
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        color: Color(0xffeeeeee),
                                        strokeWidth: 2,
                                        semanticsValue: 'Loading',
                                      ),
                                    )
                                  : const Text('Start Now'),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Text(
                              "Update your basic expenses daily and keep track of your expenses more easily and efficiently. Don't loose focus on your saving goal.",
                              style: Theme.of(context).textTheme.displaySmall),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

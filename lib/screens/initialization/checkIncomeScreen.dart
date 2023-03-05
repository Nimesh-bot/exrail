import 'package:exrail/model/income.dart';
import 'package:exrail/repository/income_repository.dart';
import 'package:flutter/material.dart';

import '../../app/customInputFields.dart';
import '../../app/snackbar.dart';
import '../../repository/user_repository.dart';

class CheckIncomeScreen extends StatefulWidget {
  const CheckIncomeScreen({super.key});

  @override
  State<CheckIncomeScreen> createState() => _CheckIncomeScreenState();
}

class _CheckIncomeScreenState extends State<CheckIncomeScreen> {
  bool _showUpdateIncome = true;
  final _monthlyController = TextEditingController();
  final _savingController = TextEditingController();
  bool _isLoading = false;
  bool _hasIncome = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _checkIfHasIncome();
  }

  _checkIfHasIncome() async {
    List<Income> usersIncome = await IncomeRepositoryImpl().getIncome();
    print('here');
    print('user $usersIncome');
    if (usersIncome.isNotEmpty) {
      setState(() {
        _hasIncome = true;
        _showUpdateIncome = false;
        _monthlyController.text = usersIncome[0].monthlySalary.toString();
        _savingController.text = usersIncome[0].estimatedSaving.toString();
      });
    } else {
      setState(() {
        _hasIncome = false;
        _showUpdateIncome = true;
      });
    }
  }

  _addIncome() async {
    setState(() {
      _isLoading = true;
    });

    Income income = Income(
      monthlySalary: _monthlyController.text.isEmpty
          ? 0
          : int.parse(_monthlyController.text),
      estimatedSaving: _savingController.text.isEmpty
          ? 0
          : int.parse(_savingController.text),
    );

    int incomeStatus = await IncomeRepositoryImpl().addIncome(income);
    if (incomeStatus == 1) {
      _addBalance();
    } else {
      _showMessage(incomeStatus);
    }
  }

  _updateIncome() async {
    setState(() {
      _isLoading = true;
    });

    Income income = Income(
      monthlySalary: _monthlyController.text.isEmpty
          ? 0
          : int.parse(_monthlyController.text),
      estimatedSaving: _savingController.text.isEmpty
          ? 0
          : int.parse(_savingController.text),
    );

    int incomeStatus = await IncomeRepositoryImpl().updateIncome(income);
    if (incomeStatus == 1) {
      _addBalance();
    } else {
      _showMessage(incomeStatus);
    }
  }

  _addBalance() async {
    bool status = await UserRepositoryImpl()
        .addAdditionalIncome(int.parse(_monthlyController.text));
    _showMessage(status ? 1 : 0);
  }

  _showMessage(int status) {
    setState(() {
      _isLoading = false;
    });
    if (status == 1) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      showSnackbar(context, 'Something went wrong', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 60,
                ),
                Text(
                  'Set your income',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'This will help us to calculate your balance more accurately and keep you on track of your financial goals',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(
                  height: 40,
                ),
                _hasIncome
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 25),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xff19202a),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'If your income is same as last month, you can just finalizing this step. We will use your last month income as your current income and update your balance',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showUpdateIncome = !_showUpdateIncome;
                                });
                              },
                              child: Text(
                                'If not, click here to update your income',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(color: Colors.cyan),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(
                  height: 40,
                ),
                _showUpdateIncome
                    ? Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomInputFields.buildInputFormFieldWIthPrefixIcon(
                              label: 'Monthly Income',
                              textController: _monthlyController,
                              obscureText: false,
                              prefixIcon: 'Rs. ',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your monthly income';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            CustomInputFields.buildInputFormFieldWIthPrefixIcon(
                              label: 'Saving',
                              textController: _savingController,
                              obscureText: false,
                              prefixIcon: 'Rs. ',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your monthly saving';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(height: 40),
                SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_isLoading) {
                        return;
                      } else {
                        if (_formKey.currentState!.validate()) {
                          if (_hasIncome) {
                            _updateIncome();
                          } else {
                            _addIncome();
                          }
                        }
                      }
                    },
                    child: _isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Finalize',
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:exrail/app/customInputFields.dart';
import 'package:exrail/components/customAppbarComponent.dart';
import 'package:exrail/components/loadingButton.dart';
import 'package:exrail/model/income.dart';
import 'package:exrail/repository/income_repository.dart';
import 'package:flutter/material.dart';

import '../../app/snackbar.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final _monthlyController = TextEditingController();
  final _savingController = TextEditingController();
  bool _isLoading = false;

  _getIncome() async {
    List<Income> currentIncome = await IncomeRepositoryImpl().getIncome();
    setState(() {
      _monthlyController.text = currentIncome[0].monthlySalary.toString();
      _savingController.text = currentIncome[0].estimatedSaving.toString();
    });
  }

  _updateIncome() async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (_monthlyController.text.isEmpty && _savingController.text.isEmpty) {
        showSnackbar(
            context,
            'Please enter new estimation in at least one field in you want to change',
            Colors.red);
        return;
      }
      Income income = Income(
        monthlySalary: _monthlyController.text.isEmpty
            ? 0
            : int.parse(_monthlyController.text),
        estimatedSaving: _savingController.text.isEmpty
            ? 0
            : int.parse(_savingController.text),
      );

      int status = await IncomeRepositoryImpl().updateIncome(income);
      if (status == 1) {
        _showMessage(status);
      } else {
        _showMessage(status);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showSnackbar(context, 'Something went wrong.', Colors.redAccent);
      throw Exception(e.toString());
    }
  }

  _showMessage(int status) {
    setState(() {
      _isLoading = false;
    });
    if (status > 0) {
      showSnackbar(context, 'Updated Successfully', Colors.cyan);
      _getIncome();
    } else {
      showSnackbar(context, 'Something went wrong. Please check the values',
          Colors.redAccent);
    }
  }

  @override
  void initState() {
    super.initState();
    _getIncome();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 80,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomAppBarComponent(),
                    const SizedBox(height: 40),
                    const Text(
                      'Income and Saving',
                      style: TextStyle(
                          fontSize: 21,
                          color: Color(0xffeeeeee),
                          fontFamily: 'Montserrat Bold'),
                    ),
                    const SizedBox(height: 40),
                    CustomInputFields.buildInputFormFieldWIthPrefixIcon(
                      label: 'Monthly Income',
                      textController: _monthlyController,
                      obscureText: false,
                      prefixIcon: 'Rs. ',
                    ),
                    const SizedBox(height: 20),
                    CustomInputFields.buildInputFormFieldWIthPrefixIcon(
                      label: 'Saving',
                      textController: _savingController,
                      obscureText: false,
                      prefixIcon: 'Rs. ',
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/additional');
                      },
                      child: const Text(
                        'Add additional saving/income',
                        style: TextStyle(color: Colors.cyan),
                      ),
                    ),
                  ],
                ),
                _isLoading
                    ? const LoadingButton()
                    : SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                            child: const Text('Save'),
                            onPressed: () {
                              _updateIncome();
                            }),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:exrail/components/loadingButton.dart';
import 'package:exrail/main.dart';
import 'package:exrail/model/expenses.dart';
import 'package:exrail/repository/expenses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/snackbar.dart';

class EstimatedExpensesScreen extends ConsumerStatefulWidget {
  const EstimatedExpensesScreen({super.key});

  @override
  ConsumerState<EstimatedExpensesScreen> createState() =>
      _EstimatedExpensesScreenState();
}

class _EstimatedExpensesScreenState
    extends ConsumerState<EstimatedExpensesScreen> {
  final _foodController = TextEditingController();
  final _transportController = TextEditingController();
  final _otherController = TextEditingController();
  bool _isLoading = false;

  _getCurrentExpenses() async {
    List<Expenses> currentExpenses =
        await ExpensesRepositoryImpl().getCurrentExpenses();
    setState(() {
      _foodController.text = currentExpenses[0].estimated_food.toString();
      _transportController.text =
          currentExpenses[0].estimated_transport.toString();
      _otherController.text = currentExpenses[0].estimated_expected.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentExpenses();
  }

  _updateEstimatedExpenses(WidgetRef ref) async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (_foodController.text.isEmpty &&
          _transportController.text.isEmpty &&
          _otherController.text.isEmpty) {
        showSnackbar(
            context,
            'Please enter new estimation in at least one field in you want to change',
            Colors.red);
        return;
      }
      Expenses expenses = Expenses(
        estimated_food:
            _foodController.text.isEmpty ? 0 : int.parse(_foodController.text),
        estimated_transport: _transportController.text.isEmpty
            ? 0
            : int.parse(_transportController.text),
        estimated_expected: _otherController.text.isEmpty
            ? 0
            : int.parse(_otherController.text),
      );

      List<Expenses> currentExpenses =
          await ExpensesRepositoryImpl().getCurrentExpenses();
      String expensesId = currentExpenses[0].expenseId!;

      int status = await ExpensesRepositoryImpl()
          .updateEstimatedExpenses(expenses, expensesId);
      _showMessage(status);

      if (status == 1) {
        ref.read(expensesProvider.notifier).updateEstimatedExpenses(expenses);
      }
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      throw Exception(err.toString());
    }
  }

  _showMessage(int status) {
    setState(() {
      _isLoading = false;
    });
    if (status > 0) {
      showSnackbar(context, 'Updated Successfully', Colors.cyan);
      _foodController.clear();
      _transportController.clear();
      _otherController.clear();

      Navigator.pop(context);
    } else {
      showSnackbar(context, 'Something went wrong. Please check the values',
          Colors.redAccent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.keyboard_arrow_left_rounded,
                    size: 30,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  'Estimated Expenses',
                  style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat Bold',
                      color: Color(0xffeeeeee)),
                ),
                const SizedBox(
                  height: 30,
                ),
                buildInputField('Food', _foodController,
                    'Accumulation of your daily food needs for a month'),
                const SizedBox(
                  height: 20,
                ),
                buildInputField('Transport', _transportController,
                    'Accumulation of your daily travel expenses for a month'),
                const SizedBox(
                  height: 20,
                ),
                buildInputField('Other', _otherController,
                    'Your monthly necessary expenses which may be for payment of bill or entertainment'),
                const SizedBox(
                  height: 40,
                ),
                _isLoading
                    ? const LoadingButton()
                    : SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                            onPressed: () {
                              _updateEstimatedExpenses(ref);
                            },
                            child: const Text(
                              'Save',
                            )),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputField(
      String label, TextEditingController controller, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xffeeeeee),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                'Rs. ',
                style: TextStyle(
                  color: Color(0xffeeeeee),
                  fontSize: 16,
                  fontFamily: 'Montserrat Bold',
                ),
              ),
            ),
          ),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          description,
          style: const TextStyle(color: Color(0xffaeaeae), fontSize: 14),
        ),
      ],
    );
  }
}

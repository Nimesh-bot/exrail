// ignore_for_file: use_build_context_synchronously

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:exrail/app/customInputFields.dart';
import 'package:exrail/app/snackbar.dart';
import 'package:exrail/components/customAppbarComponent.dart';
import 'package:exrail/components/loadingButton.dart';
import 'package:exrail/main.dart';
import 'package:exrail/model/expenses.dart';
import 'package:exrail/repository/expenses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repository/user_repository.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  _checkNotificationEnabled() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  @override
  void initState() {
    _checkNotificationEnabled();
    super.initState();
  }

  List<IconData> categories = [
    Icons.restaurant_menu_outlined,
    Icons.bus_alert_rounded,
    Icons.more_vert_outlined,
    Icons.question_mark_sharp
  ];
  int selectedIndex = 0;

  int estimatedTotal = 0;

  final _foodController = TextEditingController();
  final _transportController = TextEditingController();
  final _otherController = TextEditingController();
  final _uncertainController = TextEditingController();
  bool _isLoading = false;

  _updateExpenses(WidgetRef ref) async {
    setState(() {
      _isLoading = true;
    });
    try {
      Expenses expenses = Expenses(
        food:
            _foodController.text.isEmpty ? 0 : int.parse(_foodController.text),
        transport: _transportController.text.isEmpty
            ? 0
            : int.parse(_transportController.text),
        expected: _otherController.text.isEmpty
            ? 0
            : int.parse(_otherController.text),
        uncertain: _uncertainController.text.isEmpty
            ? 0
            : int.parse(_uncertainController.text),
      );

      List<Expenses> currentExpenses =
          await ExpensesRepositoryImpl().getCurrentExpenses();
      String expensesId = currentExpenses[0].expenseId!;

      int status =
          await ExpensesRepositoryImpl().updateExpenses(expenses, expensesId);

      if (status == 1) {
        ref.read(expensesProvider.notifier).updateExpenses(expenses);
      }
      _showMessage(status);

      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'basic_channel',
          title: 'Expenses Updated',
          body:
              'You have just updated your expenses. Please check the app for more details.',
        ),
      );

      if (status == 1) {
        int total = expenses.food! +
            expenses.transport! +
            expenses.expected! +
            expenses.uncertain!;
        _addBalance(total);
      } else {
        showSnackbar(context, 'Something went wrong. Please check the values',
            Colors.redAccent);
      }
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      throw Exception(err.toString());
    }
  }

  _addBalance(int value) async {
    bool status = await UserRepositoryImpl().addAdditionalIncome(-value);
    _showMessage(status ? 1 : 0);
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
      _uncertainController.clear();
    } else {
      showSnackbar(context, 'Something went wrong. Please check the values',
          Colors.redAccent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final foodEstimatedSelector =
        ref.watch(expensesProvider.select((value) => value.estimated_food));
    final transportEstimatedSelector = ref
        .watch(expensesProvider.select((value) => value.estimated_transport));
    final expectedEstimatedSelector =
        ref.watch(expensesProvider.select((value) => value.estimated_expected));

    return SingleChildScrollView(
      child: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 80,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomAppBarComponent(),
                    const SizedBox(height: 40),
                    categoryList(categories),
                    const SizedBox(height: 40),
                    FutureBuilder(
                      future: ExpensesRepositoryImpl().getCurrentExpenses(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (selectedIndex == 0) {
                            return bodyField(foodEstimatedSelector!,
                                _foodController, const Key('txtFood'));
                          }
                          if (selectedIndex == 1) {
                            return bodyField(
                                transportEstimatedSelector!,
                                _transportController,
                                const Key('txtTransport'));
                          }
                          if (selectedIndex == 2) {
                            return bodyField(expectedEstimatedSelector!,
                                _otherController, const Key('txtExpected'));
                          }
                          if (selectedIndex == 3) {
                            return bodyField(
                                estimatedTotal,
                                _uncertainController,
                                const Key('txtUncertain'));
                          }
                        } else {
                          return bodyField(
                              999999, _foodController, const Key('txtFood'));
                        }
                        return Container();
                      },
                    )
                  ],
                ),
                _isLoading
                    ? const LoadingButton()
                    : SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          key: const Key('btnUpdate'),
                          onPressed: () {
                            _updateExpenses(ref);
                          },
                          child: const Text(
                            'Update',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget categoryList(List categories) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Container(
              width: 70,
              margin: const EdgeInsets.only(right: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selectedIndex == index
                    ? Colors.cyan
                    : const Color(0xff323A47),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                categories[index],
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget bodyField(
      int estimated, TextEditingController textcontroller, Key keyValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Estimated',
              style: TextStyle(
                  fontSize: 18,
                  color: Color(0xffeeeeee),
                  fontWeight: FontWeight.w500),
            ),
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Rs.',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    children: [
                      TextSpan(
                        text: textcontroller == _uncertainController
                            ? '?'
                            : estimated.toString() == '999999'
                                ? 'xxxx'
                                : estimated.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    // navigate to edit screen
                    Navigator.pushNamed(context, '/estimated');
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.cyan,
                  ),
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 20),
        CustomInputFields.buildInputFormField(
          keyValue: keyValue,
          label: "Today's",
          textController: textcontroller,
          obscureText: false,
        )
      ],
    );
  }
}

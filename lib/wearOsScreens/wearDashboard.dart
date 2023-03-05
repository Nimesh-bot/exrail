import 'package:exrail/repository/expenses_repository.dart';
import 'package:flutter/material.dart';
import 'package:wear/wear.dart';

class WearDashboardScreen extends StatefulWidget {
  const WearDashboardScreen({super.key});

  @override
  State<WearDashboardScreen> createState() => _WearDashboardScreenState();
}

class _WearDashboardScreenState extends State<WearDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return WatchShape(
        builder: (BuildContext context, WearShape shape, Widget? child) {
      return AmbientMode(builder: (context, mode, child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text(
                    'Expenses',
                    style: TextStyle(
                      color: Color(0xffeeeeee),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(
                    future: ExpensesRepositoryImpl().getCurrentExpenses(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return buildExpensesCard(
                            const Icon(
                              Icons.restaurant,
                              color: Colors.cyan,
                              size: 14,
                            ),
                            'Food',
                            snapshot.data![0].food!,
                            snapshot.data![0].estimated_food!);
                      }
                      return buildLoadingExpensesGrid();
                    },
                  ),
                  FutureBuilder(
                    future: ExpensesRepositoryImpl().getCurrentExpenses(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return buildExpensesCard(
                            const Icon(
                              Icons.train_sharp,
                              color: Colors.cyan,
                              size: 14,
                            ),
                            'Transport',
                            snapshot.data![0].transport!,
                            snapshot.data![0].estimated_transport!);
                      }
                      return buildLoadingExpensesGrid();
                    },
                  ),
                  FutureBuilder(
                    future: ExpensesRepositoryImpl().getCurrentExpenses(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return buildExpensesCard(
                            const Icon(
                              Icons.attach_money,
                              color: Colors.cyan,
                              size: 14,
                            ),
                            'Expected',
                            snapshot.data![0].expected!,
                            snapshot.data![0].estimated_expected!);
                      }
                      return buildLoadingExpensesGrid();
                    },
                  ),
                  FutureBuilder(
                    future: ExpensesRepositoryImpl().getCurrentExpenses(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return buildExpensesCard(
                            const Icon(
                              Icons.question_mark,
                              color: Colors.cyan,
                              size: 14,
                            ),
                            'Uncertain',
                            snapshot.data![0].uncertain!,
                            0);
                      }
                      return buildLoadingExpensesGrid();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      });
    });
  }

  Widget buildExpensesCard(Icon icon, String label, int amount, int total) {
    return Card(
      color: const Color(0xff2C3440),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                icon,
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xffeeeeee),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rs. ${amount.toString()}',
                  style: const TextStyle(
                    color: Color(0xffeeeeee),
                    fontSize: 10,
                  ),
                ),
                Text(
                  '/   Rs. ${total.toString()}',
                  style: const TextStyle(
                    color: Color(0xffaeaeae),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoadingExpensesGrid() {
    return Card(
      color: const Color(0xff2C3440),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                    color: Colors.cyan,
                  ),
                ),
                Text(
                  'Loading',
                  style: TextStyle(color: Color(0xffeeeeee), fontSize: 10),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Rs. xxx',
                  style: TextStyle(color: Color(0xffeeeeee), fontSize: 10),
                ),
                Text(
                  '/   Rs. xxx',
                  style: TextStyle(color: Color(0xffaeaeae), fontSize: 10),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

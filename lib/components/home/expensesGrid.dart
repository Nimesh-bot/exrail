import 'package:exrail/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpensesGrid extends ConsumerStatefulWidget {
  const ExpensesGrid({super.key});

  @override
  ConsumerState<ExpensesGrid> createState() => _ExpensesGridState();
}

class _ExpensesGridState extends ConsumerState<ExpensesGrid> {
  @override
  Widget build(BuildContext context) {
    // final expenses = ref.watch(expensesProvider);

    return ref.watch(fetchExpensesProvider).when(
      data: (data) {
        return Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          alignment: WrapAlignment.start,
          spacing: 10,
          runSpacing: 10,
          children: [
            expensesCardBuilder(
              'Food',
              data[0].food!,
              data[0].estimated_food!.toString(),
              const Icon(
                Icons.food_bank,
                color: Colors.white,
              ),
            ),
            expensesCardBuilder(
              'Travel',
              data[0].transport!,
              data[0].estimated_transport!.toString(),
              const Icon(
                Icons.train,
                color: Color(0xffC9C9C9),
                size: 30,
              ),
            ),
            expensesCardBuilder(
              'Expected',
              data[0].expected!,
              data[0].estimated_expected!.toString(),
              const Icon(
                Icons.attach_money,
                color: Color(0xffC9C9C9),
                size: 30,
              ),
            ),
            expensesCardBuilder(
              'Uncertain',
              data[0].uncertain!,
              '?',
              const Icon(
                Icons.more_horiz,
                color: Color(0xffC9C9C9),
                size: 30,
              ),
            ),
          ],
        );
      },
      loading: () {
        return Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          alignment: WrapAlignment.start,
          spacing: 10,
          runSpacing: 10,
          children: [
            buildLoadingExpensesGrid(),
            buildLoadingExpensesGrid(),
            buildLoadingExpensesGrid(),
            buildLoadingExpensesGrid(),
          ],
        );
      },
      error: (err, stack) {
        return Center(
          child: Text(
            err.toString(),
            style: Theme.of(context).textTheme.displaySmall,
          ),
        );
      },
    );

    // return Wrap(
    //   crossAxisAlignment: WrapCrossAlignment.start,
    //   alignment: WrapAlignment.start,
    //   spacing: 10,
    //   runSpacing: 10,
    //   children: [
    //     FutureBuilder(
    //       future: ExpensesRepositoryImpl().getCurrentExpenses(),
    //       builder: (context, snapshot) {
    //         if (snapshot.hasData) {
    //           return expensesCardBuilder(
    //             'Food',
    //             expenses.food!,
    //             expenses.estimated_food!.toString(),
    //             const Icon(
    //               Icons.food_bank,
    //               color: Color(0xffC9C9C9),
    //               size: 30,
    //             ),
    //           );
    //         } else {
    //           return buildLoadingExpensesGrid();
    //         }
    //       },
    //     ),
    //     FutureBuilder(
    //       future: ExpensesRepositoryImpl().getCurrentExpenses(),
    //       builder: (context, snapshot) {
    //         if (snapshot.hasData) {
    //           return expensesCardBuilder(
    //             'Travel',
    //             expenses.transport!,
    //             expenses.estimated_transport!.toString(),
    //             const Icon(
    //               Icons.train,
    //               color: Color(0xffC9C9C9),
    //               size: 30,
    //             ),
    //           );
    //         } else {
    //           return buildLoadingExpensesGrid();
    //         }
    //       },
    //     ),
    //     FutureBuilder(
    //       future: ExpensesRepositoryImpl().getCurrentExpenses(),
    //       builder: (context, snapshot) {
    //         if (snapshot.hasData) {
    //           return expensesCardBuilder(
    //             'Expected',
    //             expenses.expected!,
    //             expenses.estimated_expected!.toString(),
    //             const Icon(
    //               Icons.attach_money,
    //               color: Color(0xffC9C9C9),
    //               size: 30,
    //             ),
    //           );
    //         } else {
    //           return buildLoadingExpensesGrid();
    //         }
    //       },
    //     ),
    //     FutureBuilder(
    //       future: ExpensesRepositoryImpl().getCurrentExpenses(),
    //       builder: (context, snapshot) {
    //         if (snapshot.hasData) {
    //           return expensesCardBuilder(
    //             'Uncertain',
    //             expenses.uncertain!,
    //             '?',
    //             const Icon(
    //               Icons.question_mark_sharp,
    //               color: Color(0xffC9C9C9),
    //               size: 30,
    //             ),
    //           );
    //         } else {
    //           return buildLoadingExpensesGrid();
    //         }
    //       },
    //     ),
    //   ],
    // );
  }

  Widget expensesCardBuilder(
      String title, int amount, String total, Icon icon) {
    return (Container(
      width: 150,
      height: 160,
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        color: Color(0xff2C3440),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              icon,
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xffC9C9C9),
                  fontSize: 18,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                amount.toString(),
                style: const TextStyle(
                  color: Color(0xffffffff),
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '/ $total',
                style: const TextStyle(
                  color: Color(0xffC9C9C9),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }

  Widget buildLoadingExpensesGrid() {
    return Container(
      width: 150,
      height: 160,
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        color: Color(0xff2C3440),
      ),
    );
  }
}

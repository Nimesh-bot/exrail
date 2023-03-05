import 'dart:async';

import 'package:all_sensors/all_sensors.dart';
import 'package:exrail/components/customAppbarComponent.dart';
import 'package:flutter/material.dart';

import 'package:exrail/components/home/expensesGrid.dart';
import 'package:exrail/components/home/balanceCard.dart';

import 'package:calendar_timeline/calendar_timeline.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // accelorometer sensor
  List<double> _accelerometerValue = [];
  final List<StreamSubscription<dynamic>> _streamSubscription = [];

  @override
  void initState() {
    _streamSubscription.add(accelerometerEvents!.listen((event) {
      setState(() {
        _accelerometerValue = [event.x, event.y, event.z];
      });
    }));
    super.initState();
  }

  void startAccelerometer() {
    accelerometerEvents!.listen((AccelerometerEvent event) {
      if (event.x.abs() < -2.0 ||
          event.y.abs() < -2.0 ||
          event.z.abs() < -2.0) {
        Scaffold.of(context).openDrawer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    startAccelerometer();
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 20),
          child: Column(
            children: [
              const CustomAppBarComponent(),
              const SizedBox(
                height: 40,
              ),
              const BalanceCard(),
              const SizedBox(
                height: 40,
              ),
              CalendarTimeline(
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365 * 4)),
                onDateSelected: (date) => print(date),
                leftMargin: 5,
                monthColor: Colors.blueGrey,
                dayColor: const Color(0xffaeaeae),
                activeDayColor: Colors.white,
                activeBackgroundDayColor: Colors.cyan,
                dotsColor: const Color(0xFF333A47),
                selectableDayPredicate: (date) => date.day != 23,
                locale: 'en_ISO',
              ),
              const SizedBox(
                height: 40,
              ),
              const ExpensesGrid(),
            ],
          ),
        ),
      ),
    );
  }
}

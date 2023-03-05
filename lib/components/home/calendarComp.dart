// ignore_for_file: non_constant_identifier_names, avoid_types_as_parameter_names

import 'package:flutter/material.dart';
import 'package:calendar_timeline/calendar_timeline.dart';

class CalendarComponent extends StatelessWidget {
  const CalendarComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CalendarTimeline(
        showYears: false,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365 * 4)),
        leftMargin: 0,
        monthColor: Colors.white54,
        dayColor: Colors.white54,
        dayNameColor: Colors.white,
        activeDayColor: Colors.white,
        activeBackgroundDayColor: Colors.cyan,
        dotsColor: const Color(0xFF333A47),
        selectableDayPredicate: (date) => date.day != 23,
        locale: 'en',
        onDateSelected: (DateTime) {},
      ),
    );
  }
}

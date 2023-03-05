import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:exrail/app/app.dart';
import 'package:exrail/helper/objectBox.dart';
import 'package:exrail/state/objectBox_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'model/expenses.dart';
import 'model/users.dart';

final expensesProvider =
    StateNotifierProvider.autoDispose<ExpensesNotifier, Expenses>(
  (ref) => ExpensesNotifier(),
);
final userProvider = StateNotifierProvider.autoDispose<UserNotifier, Users>(
  (ref) => UserNotifier(),
);

final fetchExpensesProvider = FutureProvider.autoDispose((ref) {
  final expensesRepo = ref.watch(expensesFutureProvider);
  return expensesRepo.getCurrentExpenses();
});

void main() async {
  AwesomeNotifications().initialize(
    'resource://drawable/launcher',
    [
      NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic Notification',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Colors.cyan,
          importance: NotificationImportance.Max,
          ledColor: const Color(0xff222831),
          channelShowBadge: true),
    ],
  );

  WidgetsFlutterBinding.ensureInitialized();
  ObjectBoxInstance.deleteDatabase();
  ObjectBoxState.objectBoxInstance = await ObjectBoxInstance.init();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

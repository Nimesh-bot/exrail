import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:exrail/app/theme.data.dart';
import 'package:exrail/model/expenses.dart';
import 'package:exrail/model/users.dart';
import 'package:exrail/screens/drawer/DrawerNavigation.dart';
import 'package:exrail/screens/fakeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

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

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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
  testWidgets('Update Daily Expenses', (widgetTester) async {
    await widgetTester.pumpWidget(
      ProviderScope(
        child: GestureDetector(
          key: const Key('gestureDetector'),
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Ex-Rail',
            themeMode: ThemeMode.dark,
            initialRoute: '/',
            theme: getApplicationTheme(),
            routes: {
              '/': (context) => const DrawerNavigationScreen(),
              '/fake': (context) => const FakeScreen(),
            },
          ),
        ),
      ),
    );

    Finder txtFood = find.byKey(const Key('txtFood'));
    await widgetTester.enterText(txtFood, '150');
    Finder gestureDetector = find.byKey(const Key('gestureDetector'));
    await widgetTester.tap(gestureDetector);
    await widgetTester.pumpAndSettle(const Duration(seconds: 20));
    Finder btnUpdate = find.byKey(const Key('btnUpdate'));
    await widgetTester.tap(btnUpdate);

    await widgetTester.pumpAndSettle(const Duration(seconds: 15));

    expect(find.text('Yes'), findsOneWidget);
  });
}

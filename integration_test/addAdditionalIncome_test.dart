import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:exrail/screens/additionalSavingScreen.dart';
import 'package:exrail/app/theme.data.dart';
import 'package:exrail/screens/fakeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

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

  testWidgets('Add additional income', (WidgetTester tester) async {
    await tester.pumpWidget(
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
              // '/': (context) => const GoogleMapScreen(),
              '/': (context) => const AdditionalSavingScreen(),
              '/home': (context) => const FakeScreen(),
            },
          ),
        ),
      ),
    );

    Finder txtAdditional = find.byKey(const Key('txtAdditional'));
    await tester.enterText(txtAdditional, '150');
    Finder gestureDetector = find.byKey(const Key('gestureDetector'));
    await tester.tap(gestureDetector);
    await tester.pumpAndSettle(const Duration(seconds: 5));
    Finder btnUpdate = find.byKey(const Key('btnUpdate'));
    await tester.tap(btnUpdate);

    await tester.pumpAndSettle(const Duration(seconds: 10));

    expect(find.text('Yes'), findsOneWidget);
  });
}

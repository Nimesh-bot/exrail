import 'package:exrail/app/theme.data.dart';
import 'package:exrail/screens/auth/loginScreen.dart';
import 'package:exrail/screens/fakeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login User', (WidgetTester tester) async {
    await tester.pumpWidget(
      GestureDetector(
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
            '/': (context) => const LoginScreen(),
            '/home': (context) => const FakeScreen(),
          },
        ),
      ),
    );

    Finder txtEmail = find.byKey(const Key('txtEmail'));
    await tester.enterText(txtEmail, 'nimesh.ffxiv@gmail.com');
    Finder txtPassword = find.byKey(const Key('txtPassword'));
    await tester.enterText(txtPassword, 'Password111@');
    Finder gestureDetector = find.byKey(const Key('gestureDetector'));
    await tester.tap(gestureDetector);
    await tester.pumpAndSettle(const Duration(seconds: 1));
    Finder btnLogin = find.byKey(const Key('btnLogin'));
    await tester.tap(btnLogin);

    // delay for 5 seconds
    await tester.pumpAndSettle(const Duration(seconds: 15));

    expect(find.text('Yes'), findsOneWidget);
  });
}

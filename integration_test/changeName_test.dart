import 'package:exrail/app/theme.data.dart';
import 'package:exrail/screens/fakeScreen.dart';
import 'package:exrail/screens/profile/editNameScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Edit name test', (WidgetTester tester) async {
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
              '/': (context) => const EditNameScreen(),
              '/fake': (context) => const FakeScreen(),
            },
          ),
        ),
      ),
    );

    Finder txtName = find.byKey(const Key('txtName'));
    await tester.enterText(txtName, 'Integration Testingg');
    Finder gestureDetector = find.byKey(const Key('gestureDetector'));
    await tester.tap(gestureDetector);
    await tester.pumpAndSettle(const Duration(seconds: 15));
    Finder btnUpdate = find.byKey(const Key('btnUpdate'));
    await tester.tap(btnUpdate);

    await tester.pumpAndSettle(const Duration(seconds: 15));

    expect(find.text('Yes'), findsOneWidget);
  });
}

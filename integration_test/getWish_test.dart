import 'package:exrail/app/theme.data.dart';
import 'package:exrail/screens/wishBucketScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Get Wish', (WidgetTester tester) async {
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
              '/': (context) => const WishBucketScreen(),
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 20));

    expect(find.text('Gaming Setup'), findsOneWidget);
  });
}

import 'package:exrail/app/theme.data.dart';
import 'package:exrail/screens/addWishScreen.dart';
import 'package:exrail/screens/additionalSavingScreen.dart';
import 'package:exrail/screens/auth/forgot/askEmailScreen.dart';
import 'package:exrail/screens/auth/forgot/changePassword.dart';
import 'package:exrail/screens/auth/forgot/otpVerificationScreen.dart';
import 'package:exrail/screens/auth/loginScreen.dart';
import 'package:exrail/screens/auth/profilePhotoScreen.dart';
import 'package:exrail/screens/auth/registerScreen.dart';
import 'package:exrail/screens/drawer/DrawerNavigation.dart';
import 'package:exrail/screens/estimatedExpensesScreen.dart';
import 'package:exrail/screens/initialization/checkExpensesScreen.dart';
import 'package:exrail/screens/initialization/checkIncomeScreen.dart';
import 'package:exrail/screens/profile/changePasswordScreen.dart';
import 'package:exrail/screens/profile/editNameScreen.dart';
import 'package:exrail/screens/profile/profileScreen.dart';
import 'package:exrail/screens/splash/splashScreen.dart';
import 'package:exrail/screens/wishBucketScreen.dart';
import 'package:exrail/wearOsScreens/wearDashboard.dart';
import 'package:exrail/wearOsScreens/wearLogin.dart';

import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ex-Rail',
      themeMode: ThemeMode.dark,
      theme: getApplicationTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const DrawerNavigationScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/register/profile': (context) => const ProfilePhotoScreen(),
        '/estimated': (context) => const EstimatedExpensesScreen(),
        '/additional': (context) => const AdditionalSavingScreen(),
        '/forgot/email': (context) => const AskEmailScreen(),
        '/forgot/verify': (context) => const OTPVerificationScreen(),
        '/forgot/change': (context) => const ChangePassword(),
        '/addWish': (context) => const AddWishScreen(),
        '/wish': (context) => const WishBucketScreen(),
        '/checkExpensesScreen': (context) => const CheckExpensesScreen(),
        '/checkIncomeScreen': (context) => const CheckIncomeScreen(),
        // profile
        '/profile': (context) => const ProfileScreen(),
        '/profile/name': (context) => const EditNameScreen(),
        '/profile/password': (context) => const ChangePasswordScreen(),
        // wearOs routes
        '/wear/login': (context) => const WearLoginScreen(),
        '/wear/dashboard': (context) => const WearDashboardScreen(),
      },
    );
  }
}

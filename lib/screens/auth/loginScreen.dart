// ignore_for_file: use_build_context_synchronously

import 'package:exrail/app/constants.dart';
import 'package:exrail/app/customInputFields.dart';
import 'package:exrail/app/snackbar.dart';
import 'package:exrail/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isBioLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    _checkBiometric();
    _getAvailableBiometrics();
    super.initState();
  }

  _handleLogin() async {
    setState(() {
      _isLoading = true;
    });
    final isLogin = await UserRepositoryImpl().loginUser(
      _emailController.text,
      _passwordController.text,
    );
    if (isLogin) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', Constant.token);

      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacementNamed(context, '/');
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnackbar(context, 'Invalid username or password', Colors.redAccent);
    }
  }

  // biometric setups
  LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometric = false;
  List<BiometricType> _availableBiometric = [];
  final bool _isRegistered = false;

  // check if we can use biometric
  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;
    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      throw Exception(e.toString());
    }

    if (!mounted) return;
    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  // function to get available biometric types
  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics = [];
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      throw Exception(e.toString());
    }
    setState(() {
      _availableBiometric = availableBiometrics;
    });
  }

  _bioMetricLogin() async {
    bool authenticated = false;

    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to login',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: false,
        ),
      );
    } on PlatformException catch (e) {
      throw Exception(e.toString());
    }

    if (!mounted) return;

    setState(() {
      _isBioLoading = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString('bioUser');

    if (userToken != null) {
      setState(() {
        Constant.token = userToken;
        _isBioLoading = false;
      });
      Navigator.pushReplacementNamed(context, '/home');
      prefs.setString('token', Constant.token);
    } else {
      setState(() {
        _isBioLoading = false;
      });
      showSnackbar(context, 'No registration with this fingerprint found',
          Colors.redAccent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height - 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Form(
                    key: _key,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Montserrat Bold',
                            color: Color(0xffeeeeee),
                          ),
                        ),
                        const Text(
                          "Let's continue keeping track of your expenses",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'OpenSans',
                            color: Color(0xffaeaeae),
                          ),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        CustomInputFields.buildInputFormFieldWithIcon(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          keyValue: const Key('txtEmail'),
                          label: 'Email',
                          icon: Icons.email,
                          obscureText: false,
                          textController: _emailController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomInputFields.buildInputFormFieldWithIcon(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          keyValue: const Key('txtPassword'),
                          label: 'Password',
                          icon: Icons.lock,
                          obscureText: true,
                          textController: _passwordController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgot/email');
                          },
                          child: const Text(
                            'Forgot Password?',
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (_isLoading)
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey,
                              ),
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      color: Colors.cyan,
                                      strokeWidth: 2,
                                      semanticsValue: 'Loading',
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Logging In',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.cyan,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              key: const Key('btnLogin'),
                              onPressed: () {
                                if (_key.currentState!.validate()) {
                                  _handleLogin();
                                }
                              },
                              child: const Text(
                                'Login',
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.fingerprint,
                              color: Colors.cyan,
                              size: 21,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            TextButton(
                              onPressed: () {
                                _bioMetricLogin();
                              },
                              child: _isBioLoading
                                  ? Row(
                                      children: const [
                                        SizedBox(
                                          width: 14,
                                          height: 14,
                                          child: CircularProgressIndicator(
                                            color: Colors.cyan,
                                            strokeWidth: 2,
                                            semanticsValue: 'Loading',
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          'Logging In',
                                        ),
                                      ],
                                    )
                                  : const Text(
                                      'Login with Fingerprint',
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Text(
                        "Don't have an account yet?",
                        style: TextStyle(color: Color(0xffaeaeae)),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text('Sign Up'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

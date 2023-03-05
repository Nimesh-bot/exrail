// ignore_for_file: use_build_context_synchronously

import 'package:exrail/app/customInputFields.dart';
import 'package:exrail/app/snackbar.dart';
import 'package:exrail/model/users.dart';
import 'package:exrail/repository/user_repository.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _key = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  _registerUser() async {
    Users user = Users(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    int status = await UserRepositoryImpl().createUser(user);
    _showMessage(status);
  }

  _showMessage(int status) {
    if (status > 0) {
      showSnackbar(context, 'Registration Successfully', Colors.cyan);
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      showSnackbar(context, 'Registration Failed', Colors.redAccent);
    }
  }

  final List<String> _passwordRules = [
    'At least 8 characters',
    'At least one number',
    'At least one uppercase',
    'At least one lowercase',
    'At least one special character',
  ];
  late bool _has8characters = true;
  late bool _hasNumber = true;
  late bool _hasUppercase = true;
  late bool _hasLowercase = true;
  late bool _hasSpecialCharacter = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: SingleChildScrollView(
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
                        'Get Started',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Montserrat Bold',
                          color: Color(0xffeeeeee),
                        ),
                      ),
                      const Text(
                        "Keep track of all your expenses and savings",
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
                        keyValue: const Key('txtFullName'),
                        label: 'Full Name',
                        icon: Icons.person,
                        textController: _nameController,
                        obscureText: false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomInputFields.buildInputFormFieldWithIcon(
                        keyValue: const Key('txtEmail'),
                        label: 'Email',
                        icon: Icons.email,
                        textController: _emailController,
                        obscureText: false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          } else if (!value.contains(RegExp(
                              r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$'))) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomInputFields.buildInputFormFieldWithIcon(
                          keyValue: const Key('txtPassword'),
                          label: 'Password',
                          icon: Icons.lock,
                          textController: _passwordController,
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              setState(() {
                                _has8characters = false;
                                _hasNumber = false;
                                _hasUppercase = false;
                                _hasLowercase = false;
                                _hasSpecialCharacter = false;
                              });
                            } else if (value.length < 8) {
                              setState(() {
                                _has8characters = false;
                              });
                            } else if (!value.contains(RegExp(r'[0-9]'))) {
                              setState(() {
                                _hasNumber = false;
                              });
                            } else if (!value.contains(RegExp(r'[A-Z]'))) {
                              setState(() {
                                _hasUppercase = false;
                              });
                            } else if (!value.contains(RegExp(r'[a-z]'))) {
                              setState(() {
                                _hasLowercase = false;
                              });
                            } else if (!value
                                .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                              setState(() {
                                _hasSpecialCharacter = false;
                              });
                            } else {
                              setState(() {
                                _has8characters = true;
                                _hasNumber = true;
                                _hasUppercase = true;
                                _hasLowercase = true;
                                _hasSpecialCharacter = true;
                              });
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Password must contain:',
                        style: TextStyle(
                          color: Color.fromARGB(174, 174, 174, 174),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // List of password requirements
                      for (var rule in _passwordRules)
                        Row(
                          children: [
                            Icon(
                              rule == _passwordRules[0]
                                  ? _has8characters
                                      ? Icons.check_circle
                                      : Icons.cancel
                                  : rule == _passwordRules[1]
                                      ? _hasNumber
                                          ? Icons.check_circle
                                          : Icons.cancel
                                      : rule == _passwordRules[2]
                                          ? _hasUppercase
                                              ? Icons.check_circle
                                              : Icons.cancel
                                          : rule == _passwordRules[3]
                                              ? _hasLowercase
                                                  ? Icons.check_circle
                                                  : Icons.cancel
                                              : rule == _passwordRules[4]
                                                  ? _hasSpecialCharacter
                                                      ? Icons.check_circle
                                                      : Icons.cancel
                                                  : Icons.cancel,
                              size: 12,
                              color:
                                  // check if the rule is met
                                  rule == _passwordRules[0]
                                      ? _has8characters
                                          ? const Color.fromARGB(
                                              174, 174, 174, 174)
                                          : Colors.red
                                      : rule == _passwordRules[1]
                                          ? _hasNumber
                                              ? const Color.fromARGB(
                                                  174, 174, 174, 174)
                                              : Colors.red
                                          : rule == _passwordRules[2]
                                              ? _hasUppercase
                                                  ? const Color.fromARGB(
                                                      174, 174, 174, 174)
                                                  : Colors.red
                                              : rule == _passwordRules[3]
                                                  ? _hasLowercase
                                                      ? const Color.fromARGB(
                                                          174, 174, 174, 174)
                                                      : Colors.red
                                                  : rule == _passwordRules[4]
                                                      ? _hasSpecialCharacter
                                                          ? const Color
                                                                  .fromARGB(174,
                                                              174, 174, 174)
                                                          : Colors.red
                                                      : Colors.red,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              rule,
                              style: const TextStyle(
                                color: Color.fromARGB(174, 174, 174, 174),
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(
                        height: 20,
                      ),
                      CustomInputFields.buildInputFormFieldWithIcon(
                        keyValue: const Key('txtConfirmPassword'),
                        label: 'Confirm Password',
                        icon: Icons.lock,
                        textController: _confirmPasswordController,
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please confirm your password';
                          } else if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          key: const Key('btnRegister'),
                          onPressed: () {
                            if (_key.currentState!.validate()) {
                              _registerUser();
                            }
                          },
                          child: const Text(
                            'Register',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(color: Color(0xffaeaeae)),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text('Log In'),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

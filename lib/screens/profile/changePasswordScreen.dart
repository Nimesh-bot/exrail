import 'package:exrail/app/customInputFields.dart';
import 'package:exrail/model/users.dart';
import 'package:flutter/material.dart';

import '../../app/snackbar.dart';
import '../../repository/user_repository.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  String _userId = '';

  _getUserId() async {
    Users user = await UserRepositoryImpl().getUserDetail();
    setState(() {
      _userId = user.userId!;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  _updatePassword() async {
    setState(() {
      _isLoading = true;
    });

    if (_userId.isNotEmpty) {
      int status = await UserRepositoryImpl().changePassword(
        _userId,
        _passwordController.text,
      );
      setState(() {
        _isLoading = false;
      });
      _showMessage(status);
    }
  }

  _showMessage(int status) {
    if (status == 1) {
      showSnackbar(context, '✔ Your password has been updated', Colors.cyan);
      _passwordController.clear();
      _confirmPasswordController.clear();
      Navigator.pushReplacementNamed(context, '/');
    } else {
      showSnackbar(context, '✖ Something went wrong', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.keyboard_arrow_left_rounded,
                    size: 30,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  'Change Password',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xff19202a),
                  ),
                  child: Text(
                    'Password must contain at least 8 characters, 1 uppercase, 1 number and 1 special character',
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Form(
                  key: _key,
                  child: Column(
                    children: [
                      CustomInputFields.buildInputFormField(
                        label: 'New Password',
                        textController: _passwordController,
                        obscureText: true,
                        keyValue: const Key('txtPassword'),
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter a password';
                          } else if (value.length < 8 ||
                              !value.contains(RegExp(r'[A-Z]')) ||
                              !value.contains(RegExp(r'[0-9]')) ||
                              !value.contains(
                                  RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                            return '* 1 uppercase, 1 number, 1 special character';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomInputFields.buildInputFormField(
                        label: 'Confirm Password',
                        textController: _confirmPasswordController,
                        obscureText: true,
                        keyValue: const Key('txtConfirmPassword'),
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter a password';
                          }
                          if (value != _passwordController.text) {
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
                          onPressed: () {
                            if (_key.currentState!.validate()) {
                              _updatePassword();
                            }
                          },
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text('Update Password'),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

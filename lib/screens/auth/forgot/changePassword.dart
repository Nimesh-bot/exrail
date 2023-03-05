import 'package:exrail/app/customInputFields.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 30),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.keyboard_backspace_rounded,
                          size: 21),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xffeeeeee),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                CustomInputFields.buildInputFormFieldWithIcon(
                  keyValue: const Key('txtPassword'),
                  label: 'New Password',
                  icon: Icons.lock,
                  obscureText: true,
                  textController: newPasswordController,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomInputFields.buildInputFormFieldWithIcon(
                  keyValue: const Key('txtConfirmPassword'),
                  label: 'Confirm Password',
                  icon: Icons.lock,
                  obscureText: true,
                  textController: confirmPasswordController,
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                    child: const Text(
                      'Submit',
                    ),
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

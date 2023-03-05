import 'package:exrail/app/customInputFields.dart';
import 'package:flutter/material.dart';

class AskEmailScreen extends StatefulWidget {
  const AskEmailScreen({super.key});

  @override
  State<AskEmailScreen> createState() => _AskEmailScreenState();
}

class _AskEmailScreenState extends State<AskEmailScreen> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
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
                      'Forgot Password',
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
                Image.asset(
                  'assets/images/vectors/mail.png',
                  height: 200,
                ),
                const SizedBox(
                  height: 40,
                ),
                const Center(
                  child: Text(
                    'Enter your email address to reset your password. We need your email address to send you a verification code.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xffeeeeee),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                CustomInputFields.buildInputFieldWithIconWithoutLabel(
                  keyValue: const Key('txtEmail'),
                  icon: Icons.email,
                  textController: _emailController,
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/forgot/verify');
                    },
                    child: const Text(
                      'Send Verification Code',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

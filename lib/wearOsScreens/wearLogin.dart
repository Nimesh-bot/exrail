import 'package:exrail/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:wear/wear.dart';

class WearLoginScreen extends StatefulWidget {
  const WearLoginScreen({super.key});

  @override
  State<WearLoginScreen> createState() => _WearLoginScreenState();
}

class _WearLoginScreenState extends State<WearLoginScreen> {
  final _emailController =
      TextEditingController(text: 'nimesh.ffxiv@gmail.com');
  final _passwordController = TextEditingController(text: 'Password888@');

  _login() async {
    final islogin = await UserRepositoryImpl()
        .loginUser(_emailController.text, _passwordController.text);
    if (islogin != null) {
      _goToAnotherPage();
    } else {
      print('error');
    }
  }

  _goToAnotherPage() {
    Navigator.pushNamed(context, '/wear/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (BuildContext context, WearShape shape, Widget? child) {
        return AmbientMode(builder: (context, mode, child) {
          return Scaffold(
              body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xffaeaeae),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: _emailController,
                        obscureText: false,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xffeeeeee),
                        ),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                            color: Color(0xffaeaeae),
                            size: 10,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xffaeaeae),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xffeeeeee),
                        ),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color(0xffaeaeae),
                            size: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      child: const Text('Login'),
                      onPressed: () {
                        _login();
                      },
                    ),
                  ),
                ]),
              ),
            ),
          ));
        });
      },
    );
  }
}

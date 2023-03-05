import 'package:flutter/material.dart';

class FakeScreen extends StatelessWidget {
  const FakeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Yes', style: Theme.of(context).textTheme.displaySmall),
      ),
    );
  }
}

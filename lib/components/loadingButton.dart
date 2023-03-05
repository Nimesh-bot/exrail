import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class LoadingButton extends StatelessWidget {
  const LoadingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey,
        ),
        onPressed: () {},
        child: Container(
          width: 18,
          height: 18,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(
            color: Colors.cyan,
            strokeWidth: 2,
            semanticsValue: 'Loading',
          ),
        ),
      ),
    );
  }
}

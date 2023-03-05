// ignore_for_file: use_build_context_synchronously

import 'package:exrail/data_source/remote_data_source/wish_data_source.dart';
import 'package:flutter/material.dart';

import '../../model/wish.dart';

class WishScreen extends StatefulWidget {
  const WishScreen({super.key});

  @override
  State<WishScreen> createState() => _WishScreenState();
}

class _WishScreenState extends State<WishScreen> {
  _getWish() async {
    List<Wish> wish = await WishRemoteDataSource().getWish();
    if (wish.isEmpty) {
      Navigator.pushReplacementNamed(context, '/addWish');
    } else {
      Navigator.pushReplacementNamed(context, '/wish');
    }
  }

  @override
  void initState() {
    _getWish();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Colors.cyan,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Searching for your wish',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ],
        ),
      ),
    );
  }
}

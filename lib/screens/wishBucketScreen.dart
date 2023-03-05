import 'package:exrail/app/snackbar.dart';
import 'package:exrail/model/users.dart';
import 'package:exrail/repository/user_repository.dart';
import 'package:exrail/repository/wish_repository.dart';
import 'package:flutter/material.dart';

import '../model/wish.dart';

class WishBucketScreen extends StatefulWidget {
  const WishBucketScreen({super.key});

  @override
  State<WishBucketScreen> createState() => _WishBucketScreenState();
}

class _WishBucketScreenState extends State<WishBucketScreen> {
  late String _wishName = 'Loading...';
  late int _wishPrice = 0;
  late num _currentBalance = 0;
  late double _wishProgress = 0;
  late String _wishId = '';

  _getWishData() async {
    List<Wish> wish = await WishRepositoryImpl().getWish();
    Users user = await UserRepositoryImpl().getUserDetail();

    setState(() {
      _wishName = wish[0].productName!;
      _wishPrice = wish[0].price!;
      _currentBalance = user.balance!;
      _wishProgress = _currentBalance / _wishPrice;
      _wishId = wish[0].wishId!;
    });
  }

  @override
  void initState() {
    _getWishData();
    super.initState();
  }

  _deleleWish() async {
    bool status = await WishRepositoryImpl().deleteWish(_wishId);
    _showMessage(status);
  }

  _showMessage(bool status) {
    if (status) {
      showSnackbar(context, 'Wish deleted', Colors.cyan);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      showSnackbar(context, 'Something went wrong', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 25,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: const Icon(
                    Icons.keyboard_arrow_left_rounded,
                    size: 30,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Wish Bucket',
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Montserrat Black',
                        color: Color(0xffeeeeee),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_sharp,
                        color: Colors.redAccent,
                      ),
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          backgroundColor: const Color(0xff323A47),
                          title: const Text(
                            'Delete Wish',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: const Text(
                            'Are you sure you want to delete?',
                            style: TextStyle(color: Color(0xffaeaeae)),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                _deleleWish();
                              },
                              child: const Text('Yes',
                                  style: TextStyle(color: Colors.redAccent)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Stack(children: [
                  FutureBuilder(
                    future: WishRepositoryImpl().getWish(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          height: MediaQuery.of(context).size.height - 300,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(snapshot.data![0].image!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      } else {
                        return buildLoadingImage();
                      }
                    },
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xff000000),
                          Color.fromARGB(123, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _wishName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xffeeeeee),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Rs. ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffaeaeae),
                                  ),
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  (_wishPrice).toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xffaeaeae),
                                  ),
                                ),
                              ],
                            )
                          ]),
                    ),
                  ),
                ]),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Progress',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xffeeeeee),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // create a progress line
                LinearProgressIndicator(
                  value: _wishProgress,
                  backgroundColor: Colors.white38,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.cyan),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: Text(
                    'Rs. $_currentBalance of Rs. $_wishPrice',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffaeaeae),
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

  Widget buildLoadingImage() {
    return Container(
      height: MediaQuery.of(context).size.height - 300,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xff323A47),
      ),
    );
  }
}

import 'package:exrail/repository/user_repository.dart';
import 'package:exrail/screens/drawer/expensesScreen.dart';
import 'package:exrail/screens/drawer/homeScreen.dart';
import 'package:exrail/screens/drawer/incomeScreen.dart';
import 'package:exrail/screens/drawer/wishScreen.dart';
import 'package:flutter/material.dart';

class DrawerNavigationScreen extends StatefulWidget {
  const DrawerNavigationScreen({super.key});

  @override
  State<DrawerNavigationScreen> createState() => _DrawerNavigationScreenState();
}

class _DrawerNavigationScreenState extends State<DrawerNavigationScreen> {
  int _selectedIndex = 0;

  List<Widget> listDrawerScreen = [
    const HomeScreen(),
    const ExpensesScreen(),
    const IncomeScreen(),
    const WishScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listDrawerScreen[_selectedIndex],
      drawer: Drawer(
        backgroundColor: const Color(0xff222831),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                    child: Text(
                      'Ex-Rail',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat Black',
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 20,
                    ),
                    width: double.infinity,
                    color: Colors.cyan,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Available Balance',
                          style: TextStyle(
                            color: Color(0xffeeeeee),
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        FutureBuilder(
                          future: UserRepositoryImpl().getUserDetail(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return RichText(
                                text: TextSpan(
                                  text: 'Rs. ',
                                  style: const TextStyle(
                                    color: Color(0xffeeeeee),
                                    fontFamily: 'OpenSans',
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: snapshot.data!.balance!.toString(),
                                      style: const TextStyle(
                                        color: Color(0xffeeeeee),
                                        fontFamily: 'Montserrat Black',
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return const Text(
                                'XXXX.XX',
                                style: TextStyle(
                                  color: Color(0xffeeeeee),
                                  fontFamily: 'OpenSans',
                                  fontSize: 14,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              title: Row(
                children: [
                  const Icon(
                    Icons.space_dashboard,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text('Dashboard',
                      style: Theme.of(context).textTheme.displaySmall),
                ],
              ),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Row(
                children: [
                  const Icon(
                    Icons.monetization_on,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text('Expenses',
                      style: Theme.of(context).textTheme.displaySmall),
                ],
              ),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Row(
                children: [
                  const Icon(
                    Icons.wallet,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text('Income',
                      style: Theme.of(context).textTheme.displaySmall),
                ],
              ),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text('Wish Bucket',
                      style: Theme.of(context).textTheme.displaySmall),
                ],
              ),
              onTap: () {
                setState(() {
                  _selectedIndex = listDrawerScreen.length - 1;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

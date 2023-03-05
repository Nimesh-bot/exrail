import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:exrail/app/customInputFields.dart';
import 'package:exrail/app/snackbar.dart';
import 'package:exrail/repository/user_repository.dart';
import 'package:flutter/material.dart';

class AdditionalSavingScreen extends StatefulWidget {
  const AdditionalSavingScreen({super.key});

  @override
  State<AdditionalSavingScreen> createState() => _AdditionalSavingScreenState();
}

class _AdditionalSavingScreenState extends State<AdditionalSavingScreen> {
  _checkNotificationEnabled() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  @override
  void initState() {
    _checkNotificationEnabled();
    super.initState();
  }

  final _amountController = TextEditingController();
  final _key = GlobalKey<FormState>();

  _addAdditional() async {
    try {
      bool status = await UserRepositoryImpl()
          .addAdditionalIncome(int.parse(_amountController.text));
      _showMessage(status);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  _showMessage(bool status) {
    if (status) {
      showSnackbar(
          context, '${_amountController.text} added to balance', Colors.cyan);
      _amountController.clear();
      Navigator.pushNamed(context, '/home');
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'basic_channel',
          title: 'Balance Updated',
          body:
              'You just received Rs. ${_amountController.text} as additional income. Please check the app for more details.',
        ),
      );
    } else {
      showSnackbar(context, 'Something went wrong', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Form(
                    key: _key,
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
                        const Text(
                          'Additional',
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat Bold',
                              color: Color(0xffeeeeee)),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        CustomInputFields.buildInputFormFieldWIthPrefixIcon(
                          label: 'Amount',
                          keyValue: const Key('txtAdditional'),
                          textController: _amountController,
                          obscureText: false,
                          prefixIcon: 'Rs. ',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter amount';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      key: const Key('btnUpdate'),
                      onPressed: () {
                        if (_key.currentState!.validate()) _addAdditional();
                      },
                      child: const Text(
                        'Save',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

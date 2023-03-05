import 'package:exrail/app/customInputFields.dart';
import 'package:exrail/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/snackbar.dart';
import '../../model/users.dart';
import '../../repository/user_repository.dart';

class EditNameScreen extends ConsumerStatefulWidget {
  const EditNameScreen({super.key});

  @override
  ConsumerState<EditNameScreen> createState() => _EditNameScreenState();
}

class _EditNameScreenState extends ConsumerState<EditNameScreen> {
  final TextEditingController _nameController = TextEditingController();
  final _key = GlobalKey<FormState>();
  bool _isLoading = false;

  _updateName(WidgetRef ref) async {
    setState(() {
      _isLoading = true;
    });
    bool status = await UserRepositoryImpl().updateUserInfo(
      Users(
        name: _nameController.text,
      ),
    );
    setState(() {
      _isLoading = false;
    });

    if (status) {
      ref.read(userProvider.notifier).updateUserName(_nameController.text);
    }

    _showMessage(status);
  }

  _showMessage(bool status) {
    if (status) {
      showSnackbar(context, '✔ Your name has been updated', Colors.cyan);
      _nameController.clear();
    } else {
      showSnackbar(context, '✖ Something went wrong', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
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
            const SizedBox(height: 40),
            Text('Edit Your Name',
                style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 40),
            Form(
              key: _key,
              child: Column(
                children: [
                  CustomInputFields.buildInputFormField(
                    label: 'Full Name',
                    textController: _nameController,
                    keyValue: const Key('txtName'),
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                        key: const Key('btnUpdate'),
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            _updateName(ref);
                          }
                        },
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text('Update Name')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

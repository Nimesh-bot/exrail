// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:exrail/app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/snackbar.dart';
import '../../main.dart';
import '../../model/users.dart' hide Image;
import '../../repository/user_repository.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String _name = 'Loading...';
  String _email = 'loading@example.com';
  String _imageUrl = '';
  num _balance = 0;
  num _discipline = 0;
  bool _isLoading = false;

  _getUsersDetail() async {
    final user = await UserRepositoryImpl().getUserDetail();
    setState(() {
      _name = user.name!;
      _email = user.email!;
      _imageUrl = user.image!.imgUrl;
      _balance = user.balance!;
      _discipline = user.disciplineLevel!;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUsersDetail();
    _checkBiometric();
    _getAvailableBiometrics();
    _getAvailableFingerprint();
  }

  // to format the curreny value
  final oCcy = NumberFormat("#,##0", "en_US");

  // fingerprint
  LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometric = false;
  List<BiometricType> _availableBiometric = [];
  bool _isRegistered = false;

  // check if we can use biometric
  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;
    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      throw Exception(e.toString());
    }

    if (!mounted) return;
    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  // function to get available biometric types
  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics = [];
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      throw Exception(e.toString());
    }
    setState(() {
      _availableBiometric = availableBiometrics;
    });
  }

  // check if user's fingerprint is registered
  Future<void> _getAvailableFingerprint() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? bioUser = prefs.getString('bioUserId');
    await _getUsersDetail();
    if (bioUser == _email) {
      setState(() {
        _isRegistered = true;
      });
    }
  }

  // function to authenticate user
  Future<void> _authenticateUser() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Please register your fingerprint.',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: false,
        ),
      );
    } on PlatformException catch (e) {
      throw Exception(e.toString());
    }

    if (!mounted) return;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? hasUser = prefs.getString('bioUser');
    if (hasUser != null && hasUser != Constant.token) {
      showSnackbar(context,
          '✖ Fingerprint already registered for different account', Colors.red);
      return;
    }
    await prefs.setString('bioUser', Constant.token);
    await prefs.setString('bioUserId', _email);

    showSnackbar(context, '✔ Fingerprint registered', Colors.cyan);
  }

  // function to remove fingerprint
  Future<void> _removeFingerprint() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('bioUser');
    await prefs.remove('bioUserId');
    showSnackbar(context, '✔ Fingerprint removed', Colors.cyan);
  }

  // logout
  Future<void> _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushNamedAndRemoveUntil(
        context, '/', (Route<dynamic> route) => false);
  }

  // image utilities
  File? _img;
  Future _browseImage(ImageSource imageSource) async {
    try {
      // Source is either Gallary or Camera
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image != null) {
        setState(() {
          _img = File(image.path);
        });
        Navigator.pop(context);
      } else {
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _updateUserImage(WidgetRef ref) async {
    setState(() {
      _isLoading = true;
    });
    bool status = await UserRepositoryImpl().updateUserImage(_img);
    _showMessage(status);

    if (status) {
      Users user = await _getUsersDetail();
      ref
          .read(userProvider.notifier)
          .updateUserImage(user.image!.imgUrl, user.image!.imgKey);
    }
  }

  _showMessage(bool status) {
    setState(() {
      _isLoading = false;
    });
    if (status) {
      showSnackbar(context, '✔ Profile Image has been updated', Colors.cyan);
      setState(() {
        _img = null;
      });
      _getUsersDetail();
    } else {
      showSnackbar(context, '✖ Something went wrong', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userNameSelector =
        ref.watch(userProvider.select((value) => value.name));
    final userEmailSelector =
        ref.watch(userProvider.select((value) => value.email));

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_img != null) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: const Color(0xff323A47),
                                  title: Text('Discard changes?',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium),
                                  content: Text(
                                    'Are you sure you want to discard the changes?',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _img = null;
                                        });
                                        Navigator.pushReplacementNamed(
                                            context, '/home');
                                      },
                                      child: const Text(
                                        'Discard',
                                        style:
                                            TextStyle(color: Colors.redAccent),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          child: const Icon(
                            Icons.keyboard_arrow_left_rounded,
                            size: 30,
                          ),
                        ),
                        Row(
                          children: [
                            _img != null
                                ? _isLoading
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          color: Colors.cyan,
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          _updateUserImage(ref);
                                        },
                                        child: const Icon(
                                          Icons.save_as_rounded,
                                          size: 24,
                                          color: Colors.cyan,
                                        ),
                                      )
                                : const SizedBox(),
                            const SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: const Color(0xff323A47),
                                    title: Text('Logout?',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium),
                                    content: Text(
                                      'Are you sure you want to logout?',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _logout();
                                        },
                                        child: const Text(
                                          'Yes',
                                          style: TextStyle(
                                              color: Colors.redAccent),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons.logout_rounded,
                                size: 24,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 150,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/backgrounds/profile.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                            alignment: Alignment.center,
                            child: _img != null
                                ? buildChangedTempImage()
                                : buildUserImage()),
                      ),
                      Positioned.fill(
                          child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Positioned.fill(
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                backgroundColor: const Color(0xff323a47),
                                context: context,
                                isScrollControlled: false,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder: (context) => Padding(
                                  padding: const EdgeInsets.all(40),
                                  child: SizedBox(
                                    height: 200,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // image
                                        Text(
                                          'Upload Image',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium,
                                        ),
                                        Text(
                                          'Either choose from gallery or take a picture',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall,
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Column(
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                _browseImage(
                                                    ImageSource.camera);
                                              },
                                              child: Row(
                                                children: const [
                                                  Icon(Icons.camera),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    'Camera',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _browseImage(
                                                    ImageSource.gallery);
                                              },
                                              child: Row(
                                                children: const [
                                                  Icon(Icons.image),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    'Gallery',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff323A47),
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 18,
                                color: Color(0xffeeeeee),
                              ),
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            userNameSelector!,
                            style: const TextStyle(
                              fontSize: 21,
                              color: Color(0xffeeeeee),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Center(
                          child: Text(
                            userEmailSelector!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Color(0xffaeaeae),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20.00),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.00),
                            color: const Color(0xff2C3440),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    _discipline.toStringAsFixed(2),
                                    style: const TextStyle(
                                      fontSize: 21,
                                      color: Colors.cyan,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'Discipline Level',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xffeeeeee),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                width: 2,
                                height: 50,
                                color: const Color(0xff222831),
                              ),
                              Column(
                                children: [
                                  Text(
                                    oCcy.format(_balance),
                                    style: const TextStyle(
                                      fontSize: 21,
                                      color: Colors.cyan,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'Balance (Rs.)',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xffeeeeee),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        buildInteraction(
                          const Icon(
                            Icons.person_2_rounded,
                            size: 30,
                          ),
                          'Full Name',
                          userNameSelector,
                          '/profile/name',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        buildInteraction(
                          const Icon(
                            Icons.lock,
                            size: 30,
                          ),
                          'Password',
                          'xxxxxxxx',
                          '/profile/password',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        buildInteraction(
                          const Icon(
                            Icons.fingerprint,
                            size: 30,
                          ),
                          'Biometric',
                          _isRegistered ? 'Registered' : 'Set Now',
                          '/profile/biometric',
                          isBio: true,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
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

  Widget buildUserImage() {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: _imageUrl == '' && _name == 'Loading...'
          ? Container(
              height: 120,
              width: 120,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            )
          : _imageUrl == '' && _name != 'Loading...'
              ? Container(
                  height: 120,
                  width: 120,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.cyan,
                    border: Border.all(
                      color: const Color(0xff2C3440),
                      width: 3,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    _name.substring(0, 2),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    _imageUrl,
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
    );
  }

  Widget buildChangedTempImage() {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        image: DecorationImage(
          image: FileImage(_img!),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildInteraction(Icon icon, String label, String value, String route,
      {bool isBio = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.cyan,
                borderRadius: BorderRadius.circular(10),
              ),
              child: icon,
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.cyan,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            )
          ],
        ),
        !isBio
            ? IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, route);
                },
                icon: const Icon(Icons.edit, color: Colors.cyan),
              )
            : _isRegistered
                ? IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Remove Biometric'),
                          content: const Text(
                              'Are you sure you want to remove your biometric?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel')),
                            TextButton(
                                onPressed: () {
                                  _removeFingerprint();
                                  Navigator.pop(context);
                                },
                                child: const Text('Remove')),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.remove_circle, color: Colors.red))
                : IconButton(
                    onPressed: () {
                      _authenticateUser();
                    },
                    icon: const Icon(Icons.add, color: Colors.cyan),
                  ),
      ],
    );
  }
}

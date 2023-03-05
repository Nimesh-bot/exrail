// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:exrail/repository/wish_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../app/customInputFields.dart';
import '../app/snackbar.dart';
import '../app/userPermission.dart';
import '../model/wish.dart';

class AddWishScreen extends StatefulWidget {
  const AddWishScreen({super.key});

  @override
  State<AddWishScreen> createState() => _AddWishScreenState();
}

class _AddWishScreenState extends State<AddWishScreen> {
  @override
  void initState() {
    _checkUserPermission();
    super.initState();
  }

  _checkUserPermission() async {
    await UserPermission.checkCameraPermission();
  }

  final key = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final priceController = TextEditingController();

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

  _saveWish() async {
    Wish wish = Wish(
      productName: nameController.text,
      price: int.parse(priceController.text),
    );

    if (_img == null) {
      showSnackbar(context, '✖ Please upload an image', Colors.red);
      return;
    }

    bool status = await WishRepositoryImpl().addWish(_img, wish);
    _showMessage(status);
  }

  _showMessage(bool status) {
    if (status) {
      showSnackbar(context, '✔ Your wish has been created', Colors.cyan);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      showSnackbar(context, '✖ Something went wrong', Colors.red);
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
                buildForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildForm() {
    return SingleChildScrollView(
      child: Form(
        key: key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Wish Bucket',
              style: TextStyle(
                fontFamily: 'Montserrat Bold',
                fontSize: 21,
                color: Color(0xffeeeeee),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color(0xff19202a),
              ),
              child: const Text(
                'Note that, you cannot add more than one product to your wish bucket.',
                style: TextStyle(
                  color: Color(0xffeeeeee),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            CustomInputFields.buildInputFormField(
              keyValue: const Key('txtProduct'),
              label: 'Product Name',
              textController: nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter product name';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            CustomInputFields.buildInputFormFieldWIthPrefixIcon(
              label: 'Price',
              textController: priceController,
              prefixIcon: 'Rs. ',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter price';
                }
                return null;
              },
            ),
            // Image picker
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Upload Product Image',
              style: TextStyle(
                color: Color(0xffeeeeee),
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            buildImageField(),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                child: const Text('Save'),
                onPressed: () {
                  if (key.currentState!.validate()) {
                    _saveWish();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildImageField() {
    return _img == null
        ? InkWell(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // image
                        Text(
                          'Upload Image',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        Text(
                          'Either choose from gallery or take a picture',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Column(
                          children: [
                            TextButton(
                              onPressed: () {
                                _browseImage(ImageSource.camera);
                              },
                              child: Row(
                                children: const [
                                  Icon(Icons.camera),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Camera',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _browseImage(ImageSource.gallery);
                              },
                              child: Row(
                                children: const [
                                  Icon(Icons.image),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Gallery',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
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
                height: 200,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: Color(0xff323a47),
                  //  add dashed border
                ),
                child: const Text(
                  'Click here to upload image of product',
                  style: TextStyle(
                    color: Color(0xffaeaeae),
                  ),
                )),
          )
        : Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: FileImage(_img!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: -10,
                right: -10,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _img = null;
                    });
                  },
                  child: Container(
                    decoration: ShapeDecoration(
                      color: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          );
  }
}

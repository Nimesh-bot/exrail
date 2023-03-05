import 'package:flutter/material.dart';

class CustomInputFields {
  static Widget buildInputFormFieldWithIcon({
    String label = '',
    required IconData icon,
    bool obscureText = false,
    required TextEditingController textController,
    required Key keyValue,
    String? Function(String?)? validator,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xffaeaeae),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          key: keyValue,
          controller: textController,
          validator: validator,
          obscureText: obscureText,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xffeeeeee),
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: const Color(0xffaeaeae),
              size: 18,
            ),
          ),
        ),
      ],
    );
  }

  static Widget buildInputFormField(
      {String label = '',
      bool obscureText = false,
      required TextEditingController textController,
      String? Function(String?)? validator,
      required Key keyValue}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xffaeaeae),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          key: keyValue,
          controller: textController,
          obscureText: obscureText,
          validator: validator,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xffeeeeee),
          ),
        ),
      ],
    );
  }

  static Widget buildInputFormFieldWIthPrefixIcon({
    String label = '',
    required String prefixIcon,
    bool obscureText = false,
    required TextEditingController textController,
    String? Function(String?)? validator,
    Key? keyValue,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xffaeaeae),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          key: keyValue,
          validator: validator,
          controller: textController,
          obscureText: obscureText,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xffeeeeee),
          ),
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                prefixIcon,
                style: const TextStyle(
                  color: Color(0xffeeeeee),
                  fontSize: 16,
                  fontFamily: 'Montserrat Bold',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static buildInputFieldWithIconWithoutLabel({
    required IconData icon,
    bool obscureText = false,
    required TextEditingController textController,
    required Key keyValue,
  }) {
    return TextFormField(
      key: keyValue,
      controller: textController,
      obscureText: obscureText,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xffeeeeee),
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: const Color(0xffaeaeae),
          size: 18,
        ),
      ),
    );
  }
}

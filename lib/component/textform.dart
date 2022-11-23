import 'package:flutter/material.dart';

Widget textform(
      {String? label,
      IconData? icon,
      Widget? suffixIcon,
      String? initialValue,
      //TextEditingController? controller,
      bool readOnly = false,
      bool obscureText = false}) {
    return TextFormField(
      readOnly: readOnly,
      initialValue: initialValue,
      obscureText: obscureText,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        icon: Icon(
          icon,
          color: Colors.grey,
        ),
        labelText: label,
      ),
    );
  }
import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/style.dart';

class MyTextForm extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? Function(String?)? validatior;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Iterable<String>? autofillHints;
  const MyTextForm(
      {Key? key,
      required this.controller,
      this.validatior,
      this.onChanged,
      this.labelText,
      this.suffixIcon,
      required this.obscureText,
      this.autofillHints,
      this.keyboardType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: style.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColor.primaryColor.withOpacity(0.9),
      ),
      obscureText: obscureText,
      autofillHints: autofillHints,
      cursorColor: Colors.black54,
      keyboardType: keyboardType,
      controller: controller,
      onChanged: onChanged,
      validator: validatior,
      decoration: InputDecoration(
        fillColor: Colors.transparent,
        filled: true,
        hintText: labelText,
        hintStyle: style.copyWith(
          fontSize: 15,
          color: AppColor.darkGrey.withOpacity(0.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(
            color: AppColor.red,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(
            color: AppColor.red,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(
            color: AppColor.primaryColor.withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(
            color: AppColor.primaryColor.withOpacity(0.2),
          ),
        ),
        suffixIcon: suffixIcon,
      ),
    );
    // TextFormField(
    //     obscureText: obscureText,
    //     cursorColor: Colors.black54,
    //     keyboardType: keyboardType,
    //     controller: controller,
    //     onChanged: onChanged,
    //     validator: validatior,
    //     decoration: InputDecoration(
    //       hintText: labelText,
    //       hintStyle: TextStyle(color: AppColor.textFormColor),
    //       fillColor: Colors.white,
    //       errorBorder: OutlineInputBorder(
    //         borderRadius: BorderRadius.circular(6.0),
    //         borderSide: BorderSide(
    //           color: AppColor.textFormColor,
    //         ),
    //       ),
    //       focusedErrorBorder: OutlineInputBorder(
    //         borderRadius: BorderRadius.circular(6.0),
    //         borderSide: BorderSide(
    //           color: AppColor.textFormColor,
    //         ),
    //       ),
    //       focusedBorder: OutlineInputBorder(
    //         borderRadius: BorderRadius.circular(6.0),
    //         borderSide: BorderSide(
    //           color: AppColor.activetextFormColor,
    //         ),
    //       ),
    //       enabledBorder: OutlineInputBorder(
    //         borderRadius: BorderRadius.circular(6.0),
    //         borderSide: BorderSide(
    //           color: AppColor.textFormColor,
    //         ),
    //       ),
    //       suffixIcon: suffixIcon,
    //     ));
  }
}

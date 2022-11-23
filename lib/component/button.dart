// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final Function()? onTap;
  final Color? backgroundColor;
  final Widget child;
  Color borderColor = Colors.transparent;
  MainButton(
      {Key? key,
      this.onTap,
      this.backgroundColor,
      required this.borderColor,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(12.0)),
        height: 50.0,
        child: Center(child: child),
      ),
    );
  }
}

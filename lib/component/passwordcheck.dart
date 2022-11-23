import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';

// ignore: must_be_immutable
class PasswordCheck extends StatelessWidget {
  final String title;
  bool isContained = false;
  bool isTextEmpty = true;
  PasswordCheck(
      {Key? key,
      required this.title,
      required this.isContained,
      required this.isTextEmpty})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14.33, bottom: 6.0, top: 6.0),
      child: Row(
        children: [
          isTextEmpty
              ? Icon(
                  Icons.radio_button_off,
                  color: AppColor.primaryColor,
                  size: 16,
                )
              : isContained
                  ? Icon(
                      Icons.check_circle,
                      color: AppColor.green,
                      size: 16,
                    )
                  : Icon(
                      Icons.cancel,
                      color: AppColor.red,
                      size: 16,
                    ),
          const SizedBox(
            width: 8,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.0,
              color: isTextEmpty
                  ? AppColor.primaryColor
                  : isContained
                      ? AppColor.green
                      : AppColor.red,
            ),
          ),
        ],
      ),
    );
  }
}

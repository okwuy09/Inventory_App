import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';

final style = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: AppColor.primaryColor,
);

final buttonCircularIndicator = SizedBox(
  height: 25,
  width: 25,
  child: CircularProgressIndicator(
    backgroundColor: AppColor.lightGrey.withOpacity(0.6),
    valueColor: AlwaysStoppedAnimation(AppColor.white),
    strokeWidth: 4.0,
  ),
);

void successOperation(context) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: const EdgeInsets.symmetric(
          horizontal: 80,
          vertical: 110,
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline_outlined,
              color: AppColor.white,
            ),
            const SizedBox(width: 10),
            Text(
              'Success',
              style: style.copyWith(color: AppColor.white),
            ),
          ],
        ),
        backgroundColor: AppColor.primaryColor,
        padding: const EdgeInsets.all(10),
        duration: const Duration(milliseconds: 3000),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );

failedOperation({context, required String message}) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 60,
        ),
        content: Text(
          message,
          style: style.copyWith(color: AppColor.white),
        ),
        backgroundColor: AppColor.red.withOpacity(0.9),
        padding: const EdgeInsets.all(10),
        duration: const Duration(milliseconds: 5000),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );

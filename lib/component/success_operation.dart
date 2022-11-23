import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/style.dart';

void successOperation(context) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: const EdgeInsets.all(100),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_outlined,
              color: AppColor.white,
              //size: 2,
            ),
            const SizedBox(width: 10),
            Text(
              'Success',
              style: style.copyWith(color: AppColor.white),
            ),
          ],
        ),
        backgroundColor: Colors.green.withOpacity(0.8),
        padding: const EdgeInsets.all(10),
        duration: const Duration(milliseconds: 3000),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );

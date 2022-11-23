import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/button.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/popover.dart';
import 'package:viicsoft_inventory_app/component/style.dart';

// print(months[mon+1]);

void confirmDeleteSheet({
  context,
  Function()? onTapRedButton,
  Function()? onTapBlackButton,
  required String title,
  required String blackbuttonText,
  required String redbuttonText,
}) {
  showModalBottomSheet<int>(
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      return Popover(
        mainAxisSize: MainAxisSize.min,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: style.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    MainButton(
                      onTap: onTapBlackButton,
                      child: Text(
                        blackbuttonText,
                        style: style.copyWith(
                          fontSize: 14,
                          color: AppColor.buttonText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: AppColor.primaryColor,
                      borderColor: Colors.transparent,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: MainButton(
                        onTap: onTapRedButton,
                        child: Text(
                          redbuttonText,
                          style: style.copyWith(
                            fontSize: 14,
                            color: AppColor.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: const Color(0xffFEEAEA),
                        borderColor: Colors.transparent,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      );
    },
  );
}

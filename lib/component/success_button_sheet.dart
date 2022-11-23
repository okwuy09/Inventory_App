import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/button.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/popover.dart';
import 'package:viicsoft_inventory_app/component/style.dart';

// print(months[mon+1]);

void successButtomSheet({
  context,
  Function()? onTap,
  required String title,
  required String buttonText,
}) {
  showModalBottomSheet<int>(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      return Popover(
        mainAxisSize: MainAxisSize.min,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xffC7FEE3),
                    borderRadius: BorderRadius.circular(108),
                  ),
                ),
                Positioned(
                  top: 18,
                  left: 19,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    height: 51.33,
                    width: 51.33,
                    decoration: BoxDecoration(
                      color: AppColor.green,
                      borderRadius: BorderRadius.circular(108),
                    ),
                    child: Icon(
                      Icons.check,
                      color: AppColor.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/PartyPopperL.png',
                  height: 32,
                  width: 32,
                ),
                Container(
                  child: Text(
                    title,
                    style: style.copyWith(color: AppColor.black, fontSize: 22),
                  ),
                  alignment: Alignment.center,
                ),
                Image.asset(
                  'assets/PartyPopperR.png',
                  height: 32,
                  width: 32,
                ),
              ],
            ),
            const SizedBox(height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 50,
                    bottom: 20,
                  ),
                  child: MainButton(
                    onTap: onTap,
                    child: Text(
                      buttonText,
                      style: style.copyWith(
                        fontSize: 14,
                        color: AppColor.buttonText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: AppColor.primaryColor,
                    borderColor: Colors.transparent,
                  ),
                )
              ],
            ),
          ],
        ),
      );
    },
  );
}

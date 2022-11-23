import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/style.dart';

class DateField extends StatelessWidget {
  final String pickedDate;
  final Function()? onPressed;
  const DateField({Key? key, required this.pickedDate, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      height: 60,
      width: screenSize.width,
      decoration: BoxDecoration(
        color: AppColor.homePageColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColor.textFormColor,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              pickedDate,
              style: style,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(child: Container()),
          Container(
            height: 60,
            width: 63,
            decoration: BoxDecoration(
              color: AppColor.textFormColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.calendar_month_outlined,
                size: 30,
                color: Color(0xff35383A),
              ),
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }
}

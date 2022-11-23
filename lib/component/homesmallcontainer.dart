import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';

class HomeSmallContainer extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final String totalCount;
  final Color? buttonColor;
  final Color borderColor;
  final Function()? onTap;
  const HomeSmallContainer({
    Key? key,
    required this.onTap,
    required this.buttonColor,
    required this.borderColor,
    required this.title,
    required this.backgroundColor,
    required this.totalCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 16, left: 6, right: 6),
      height: screensize.height * 0.17,
      width: screensize.width * 0.29,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8.0),
        color: backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Text(
              title,
              style: TextStyle(
                color: AppColor.primaryColor,
                fontFamily: 'Poppins',
                fontSize: 12,
              ),
            ),
          ),
          Expanded(child: Container()),
          Divider(
            thickness: 1,
            color: AppColor.buttonText,
          ),
          Expanded(child: Container()),
          Row(
            children: [
              Text(
                totalCount,
                style: TextStyle(
                    color: AppColor.primaryColor,
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(child: Container()),
              InkWell(
                onTap: onTap,
                child: Text(
                  'SEE ALL',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: buttonColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    fontSize: 10,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';

class HomeBigContainer extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color dividerColor;
  final String totalCount;
  final Function()? onTap;
  const HomeBigContainer({
    Key? key,
    required this.onTap,
    required this.title,
    required this.backgroundColor,
    required this.dividerColor,
    required this.totalCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(top: 19, bottom: 19, left: 12, right: 12),
      height: screensize.height * 0.193,
      width: screensize.width * 0.29,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColor.white,
              fontFamily: 'Poppins',
              fontSize: 12,
            ),
          ),
          Expanded(child: Container()),
          Divider(
            thickness: 2,
            color: dividerColor,
          ),
          Expanded(child: Container()),
          Row(
            children: [
              Text(
                totalCount,
                style: TextStyle(
                    color: AppColor.white,
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
                    color: AppColor.white,
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

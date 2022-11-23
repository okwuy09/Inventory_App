import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';

class HomeActivitiesContainer extends StatelessWidget {
  final String title;
  final String description;
  const HomeActivitiesContainer(
      {Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    return Container(
      height: screensize.height * 0.13,
      width: screensize.width,
      padding:
          const EdgeInsets.only(bottom: 20, left: 15.0, right: 15.0, top: 15.0),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColor.black,
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Text(
            description,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColor.darkGrey,
            ),
          )
        ],
      ),
    );
  }
}

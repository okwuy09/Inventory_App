import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/style.dart';

class StoreCount extends StatelessWidget {
  final Color? backgroundColor;
  final Color? textColor;
  final String? conditionName;
  const StoreCount(
      {Key? key, this.backgroundColor, this.conditionName, this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 37,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          8,
        ),
      ),
      child: Center(
        child: Text(
          conditionName!,
          style: style.copyWith(
            fontSize: 12,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

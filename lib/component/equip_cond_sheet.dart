import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/button.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/popover.dart';
import 'package:viicsoft_inventory_app/component/style.dart';

void equipmentConditionbuttomSheet(
    context,
    String equipmentImage,
    String equipmentName,
    String equipmentDescription,
    String conditionName,
    Color? conditionBoxColor,
    Color? conditionTextColor) {
  showModalBottomSheet<int>(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      // ignore: sized_box_for_whitespace
      return Container(
        height: MediaQuery.of(context).size.height * 0.63,
        child: Popover(
          mainAxisSize: MainAxisSize.max,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(equipmentImage), fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(4)),
                height: 150,
              ),
              const SizedBox(height: 15),
              // ignore: avoid_unnecessary_containers
              Container(
                child: Text(
                  equipmentName,
                  style: style.copyWith(color: AppColor.black, fontSize: 24),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                equipmentDescription,
                style: style.copyWith(
                  color: AppColor.darkGrey,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    height: 37,
                    width: 52,
                    decoration: BoxDecoration(
                        color: conditionBoxColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(
                        conditionName,
                        style: style.copyWith(
                          fontSize: 12,
                          color: conditionTextColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      MainButton(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'SEE OTHER EQUIPMENT IN THIS CATEGORY',
                          style: style.copyWith(
                            fontSize: 14,
                            color: AppColor.buttonText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: AppColor.primaryColor,
                        borderColor: Colors.transparent,
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

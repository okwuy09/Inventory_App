import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/button.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/popover.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/equipments.dart';
import 'package:viicsoft_inventory_app/ui/store/update_equipment.dart';

List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];
// print(months[mon+1]);

void equipmentDetailbuttomSheet({
  context,
  String? equipmentImage,
  String? equipmentName,
  String? condition,
  String? description,
  String? userGroup,
  EquipmentElement? equipment,
}) {
  showModalBottomSheet<int>(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.63,
        child: Popover(
          mainAxisSize: MainAxisSize.max,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(equipmentImage!),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(12)),
                height: MediaQuery.of(context).size.height * 0.18,
              ),
              const SizedBox(height: 15),
              Text(
                equipmentName!,
                style: style.copyWith(color: AppColor.black, fontSize: 24),
              ),
              const SizedBox(height: 10),
              Text(
                description!,
                style: style.copyWith(
                  color: AppColor.darkGrey,
                ),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    height: 38,
                    width: 56,
                    decoration: BoxDecoration(
                        color: condition == 'BAD'
                            ? const Color(0xffFEEAEA)
                            : condition == 'NEW' || condition == 'OLD'
                                ? const Color(0xFFEDF9F3)
                                : condition == 'FAIR'
                                    ? const Color(0xFFFFFAEC)
                                    : null,
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(
                        condition == 'BAD'
                            ? 'Bad'
                            : condition == 'NEW' || condition == 'OLD'
                                ? 'Good'
                                : condition == 'FAIR'
                                    ? 'Fair'
                                    : '',
                        style: style.copyWith(
                          fontSize: 12,
                          color: condition == 'BAD'
                              ? AppColor.red
                              : condition == 'NEW' || condition == 'OLD'
                                  ? AppColor.green
                                  : condition == 'FAIR'
                                      ? const Color(0xFFFFCC42)
                                      : null,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Divider(),
                      const SizedBox(height: 20),
                      MainButton(
                        onTap: () {
                          userGroup == '22'
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => UpdateEquipmentPage(
                                        equipment: equipment),
                                  ),
                                )
                              : Navigator.pop(context);
                        },
                        child: Text(
                          userGroup == '22' ? 'EDIT EQUIPMENTS' : 'BACK',
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viicsoft_inventory_app/component/button.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/popover.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/equipments.dart';
import 'package:viicsoft_inventory_app/services/provider/userdata.dart';
import 'package:viicsoft_inventory_app/ui/store/update_equipment.dart';

class EquipmentDetail extends StatefulWidget {
  final BuildContext ctx;
  final String equipmentImage;
  final String equipmentName;
  final String condition;
  final String description;
  final EquipmentElement equipment;
  const EquipmentDetail({
    Key? key,
    required this.condition,
    required this.ctx,
    required this.description,
    required this.equipment,
    required this.equipmentImage,
    required this.equipmentName,
  }) : super(key: key);

  @override
  State<EquipmentDetail> createState() => _EquipmentDetailState();
}

class _EquipmentDetailState extends State<EquipmentDetail> {
  @override
  Widget build(BuildContext context) {
    var priority = Provider.of<UserData>(context).userData.rolesPriority;
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
                      image: NetworkImage(widget.equipmentImage),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(12)),
              height: MediaQuery.of(context).size.height * 0.18,
            ),
            const SizedBox(height: 15),
            Text(
              widget.equipmentName,
              style: style.copyWith(color: AppColor.black, fontSize: 24),
            ),
            const SizedBox(height: 10),
            Text(
              widget.description,
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
                      color: widget.condition == 'BAD'
                          ? const Color(0xffFEEAEA)
                          : widget.condition == 'NEW' ||
                                  widget.condition == 'OLD'
                              ? const Color(0xFFEDF9F3)
                              : widget.condition == 'FAIR'
                                  ? const Color(0xFFFFFAEC)
                                  : null,
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Text(
                      widget.condition == 'BAD'
                          ? 'Bad'
                          : widget.condition == 'NEW' ||
                                  widget.condition == 'OLD'
                              ? 'Good'
                              : widget.condition == 'FAIR'
                                  ? 'Fair'
                                  : '',
                      style: style.copyWith(
                        fontSize: 12,
                        color: widget.condition == 'BAD'
                            ? AppColor.red
                            : widget.condition == 'NEW' ||
                                    widget.condition == 'OLD'
                                ? AppColor.green
                                : widget.condition == 'FAIR'
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
                        priority == 'admin'
                            ? {
                                Navigator.pop(context),
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => UpdateEquipmentPage(
                                        equipment: widget.equipment),
                                  ),
                                )
                              }
                            : Navigator.pop(context);
                      },
                      child: Text(
                        priority == 'admin' ? 'EDIT EQUIPMENTS' : 'BACK',
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
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viicsoft_inventory_app/component/button.dart';
import 'package:viicsoft_inventory_app/component/confirm_delete_sheet.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/equipment_detail.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/category.dart';
import 'package:viicsoft_inventory_app/models/equipments.dart';
import 'package:viicsoft_inventory_app/services/provider/appdata.dart';
import 'package:viicsoft_inventory_app/services/provider/userdata.dart';
import 'package:viicsoft_inventory_app/ui/store/add_equipment_page.dart';

// ignore: must_be_immutable
class EquipmentPage extends StatefulWidget {
  final EquipmentCategory equipmentCategory;
  String categoryId;
  EquipmentPage(
      {Key? key, required this.equipmentCategory, required this.categoryId})
      : super(key: key);

  @override
  State<EquipmentPage> createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> {
  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    var provider = Provider.of<AppData>(context);
    var priority = Provider.of<UserData>(context).userData.rolesPriority;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        automaticallyImplyLeading: false,
        toolbarHeight: screensize.height * 0.11,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 25,
                color: AppColor.iconBlack,
              ),
            ),
            const SizedBox(width: 16),
            Text(widget.equipmentCategory.name,
                style: style.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(width: 50),
            Expanded(child: Container()),
          ],
        ),
      ),
      backgroundColor: AppColor.white,
      body: StreamBuilder<List<EquipmentElement>>(
          stream: provider.fetchAllEquipment(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return pageCircularIndicator;
            } else {
              final results = snapshot.data!;
              var result = results
                  .where((item) =>
                      widget.categoryId.contains(item.equipmentCategoryId))
                  .toList();
              return Column(
                children: [
                  Container(
                    height: screensize.height * 0.7,
                    color: AppColor.homePageColor,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: result.length,
                            itemBuilder: (_, int index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(right: 20, left: 20),
                                child: SizedBox(
                                  height: 90,
                                  //screensize.height * 0.12,
                                  child: InkWell(
                                    onLongPress: () => {
                                      if (priority == 'admin')
                                        {
                                          confirmDeleteSheet(
                                            blackbuttonText:
                                                'NO ! MAKE I ASK OGA FEES',
                                            redbuttonText:
                                                'YES! REMOVE EQUIPMENT',
                                            title:
                                                'Are you sure you want to permanently remove ( ${result[index].equipmentName} ) ?',
                                            context: context,
                                            onTapBlackButton: () =>
                                                Navigator.pop(context),
                                            onTapRedButton: () async {
                                              provider.deleteEquipment(
                                                result[index].id,
                                                context,
                                              );
                                            },
                                          ),
                                        }
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(7),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 56,
                                                  height: 56,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          result[index]
                                                              .equipmentImage),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 15),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                    result[index]
                                                                        .equipmentName,
                                                                    maxLines: 1,
                                                                    style: style.copyWith(
                                                                        fontSize:
                                                                            14)),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(4),
                                                                  height: 37,
                                                                  width: 50,
                                                                  decoration: BoxDecoration(
                                                                      color: result[index].equipmentCondition == 'BAD'
                                                                          ? const Color(0xffFEEAEA)
                                                                          : result[index].equipmentCondition == 'NEW' || result[index].equipmentCondition == 'OLD'
                                                                              ? const Color(0xFFEDF9F3)
                                                                              : result[index].equipmentCondition == 'FAIR'
                                                                                  ? const Color(0xFFFFFAEC)
                                                                                  : null,
                                                                      borderRadius: BorderRadius.circular(8)),
                                                                  child: Center(
                                                                    child: Text(
                                                                      result[index].equipmentCondition ==
                                                                              'BAD'
                                                                          ? 'Bad'
                                                                          : result[index].equipmentCondition == 'NEW' || result[index].equipmentCondition == 'OLD'
                                                                              ? 'Good'
                                                                              : result[index].equipmentCondition == 'FAIR'
                                                                                  ? 'Fair'
                                                                                  : '',
                                                                      style: style
                                                                          .copyWith(
                                                                        fontSize:
                                                                            12,
                                                                        color: result[index].equipmentCondition ==
                                                                                'BAD'
                                                                            ? AppColor.red
                                                                            : result[index].equipmentCondition == 'NEW' || result[index].equipmentCondition == 'OLD'
                                                                                ? AppColor.green
                                                                                : result[index].equipmentCondition == 'FAIR'
                                                                                    ? const Color(0xFFFFCC42)
                                                                                    : null,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                    child:
                                                                        Container()),
                                                                InkWell(
                                                                  onTap: () =>
                                                                      showModalBottomSheet(
                                                                    isScrollControlled:
                                                                        true,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return EquipmentDetail(
                                                                        condition:
                                                                            result[index].equipmentCondition,
                                                                        ctx:
                                                                            context,
                                                                        description:
                                                                            result[index].equipmentDescription!,
                                                                        equipment:
                                                                            result[index],
                                                                        equipmentImage:
                                                                            result[index].equipmentImage,
                                                                        equipmentName:
                                                                            result[index].equipmentName,
                                                                      );
                                                                    },
                                                                  ),
                                                                  //     equipmentDetailbuttomSheet(
                                                                  //   context:
                                                                  //       context,
                                                                  //   condition: result[
                                                                  //           index]
                                                                  //       .equipmentCondition,
                                                                  //   equipmentImage:
                                                                  //       result[index]
                                                                  //           .equipmentImage,
                                                                  //   equipmentName:
                                                                  //       result[index]
                                                                  //           .equipmentName,
                                                                  //   description:
                                                                  //       result[index]
                                                                  //           .equipmentDescription,
                                                                  //   equipment:
                                                                  //       result[
                                                                  //           index],
                                                                  // ),
                                                                  child: Icon(
                                                                    Icons
                                                                        .arrow_forward_ios,
                                                                    color: AppColor
                                                                        .darkGrey,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 20, left: 20, top: 20),
                    child: MainButton(
                      borderColor: Colors.transparent,
                      child: Text(
                        priority == 'admin' ? 'ADD NEW EQUIPMENT' : 'BACK',
                        style: style.copyWith(
                          fontSize: 14,
                          color: AppColor.buttonText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: AppColor.primaryColor,
                      onTap: () => priority == 'admin'
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddEquipmentPage(
                                  category: widget.equipmentCategory,
                                ),
                              ),
                            )
                          : Navigator.pop(context),
                    ),
                  )
                ],
              );
            }
          }),
    );
  }
}

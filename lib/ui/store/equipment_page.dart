import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/button.dart';
import 'package:viicsoft_inventory_app/component/confirm_delete_sheet.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/equipment_detail.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/category.dart';
import 'package:viicsoft_inventory_app/models/equipments.dart';
import 'package:viicsoft_inventory_app/models/profile.dart';
import 'package:viicsoft_inventory_app/services/apis/equipment_api.dart';
import 'package:viicsoft_inventory_app/services/apis/user_api.dart';
import 'package:viicsoft_inventory_app/ui/Menu/add_equipment_page.dart';

// ignore: must_be_immutable
class EquipmentPage extends StatefulWidget {
  EquipmentCategory equipmentCategory;
  String categoryId;
  EquipmentPage(
      {Key? key, required this.equipmentCategory, required this.categoryId})
      : super(key: key);

  @override
  State<EquipmentPage> createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> {
  final EquipmentAPI _equipmentAPI = EquipmentAPI();
  late final List<EquipmentElement> equipmentsList;
  late Future equipmentFuture;
  bool equipmentImage = true;

  @override
  void initState() {
    super.initState();
    equipmentFuture = _equipmentAPI.fetchAllEquipments();
  }

  Future refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
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
      body: FutureBuilder<List<Groups>>(
        future: UserAPI().fetchUserGroup(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Center();
            } else {
              var userGroup = snapshot.data!;
              for (var i = 0; i < userGroup.length; i++) {
                return Column(
                  children: [
                    Container(
                      height: screensize.height * 0.7,
                      color: AppColor.homePageColor,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Expanded(
                            child: FutureBuilder<List<EquipmentElement>>(
                                future: _equipmentAPI.fetchAllEquipments(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return SizedBox(
                                      child: Container(),
                                    );
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    final results = snapshot.data!;
                                    var result = results
                                        .where((item) => widget.categoryId
                                            .contains(item.equipmentCategoryId))
                                        .toList();
                                    return RefreshIndicator(
                                      onRefresh: refresh,
                                      child: ListView.builder(
                                        itemCount: result.length,
                                        itemBuilder: (_, int index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20, left: 20),
                                            child: SizedBox(
                                              height: 90,
                                              //screensize.height * 0.12,
                                              child: InkWell(
                                                onLongPress: () => {
                                                  if (userGroup[i].id == '22')
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
                                                            Navigator.pop(
                                                                context),
                                                        onTapRedButton:
                                                            () async {
                                                          var res = await EquipmentAPI()
                                                              .deleteEquipment(
                                                                  result[index]
                                                                      .id);
                                                          if (res.statusCode ==
                                                              200) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                                content: Text(
                                                                    "( ${result[index].equipmentName} ) Equipment successfully deleted"),
                                                              ),
                                                            );
                                                            Navigator.pop(
                                                                context);
                                                          }
                                                        },
                                                      ),
                                                    }
                                                },
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  elevation: 0,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(7),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width: 56,
                                                              height: 56,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                image:
                                                                    DecorationImage(
                                                                  image: NetworkImage(
                                                                      result[index]
                                                                          .equipmentImage),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 15),
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
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Text(result[index].equipmentName,
                                                                                maxLines: 1,
                                                                                style: style.copyWith(fontSize: 14)),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Container(
                                                                              padding: const EdgeInsets.all(4),
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
                                                                                  result[index].equipmentCondition == 'BAD'
                                                                                      ? 'Bad'
                                                                                      : result[index].equipmentCondition == 'NEW' || result[index].equipmentCondition == 'OLD'
                                                                                          ? 'Good'
                                                                                          : result[index].equipmentCondition == 'FAIR'
                                                                                              ? 'Fair'
                                                                                              : '',
                                                                                  style: style.copyWith(
                                                                                    fontSize: 12,
                                                                                    color: result[index].equipmentCondition == 'BAD'
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
                                                                            Expanded(child: Container()),
                                                                            InkWell(
                                                                              onTap: () => equipmentDetailbuttomSheet(
                                                                                context: context,
                                                                                condition: result[index].equipmentCondition,
                                                                                equipmentImage: result[index].equipmentImage,
                                                                                equipmentName: result[index].equipmentName,
                                                                                description: result[index].equipmentDescription,
                                                                                equipment: result[index],
                                                                                userGroup: userGroup[i].id,
                                                                              ),
                                                                              child: Icon(
                                                                                Icons.arrow_forward_ios,
                                                                                color: AppColor.darkGrey,
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
                                    );
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(
                                          color: AppColor.darkGrey),
                                    );
                                  }
                                }),
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
                          userGroup[i].id == '22'
                              ? 'ADD NEW EQUIPMENT'
                              : 'BACK',
                          style: style.copyWith(
                            fontSize: 14,
                            color: AppColor.buttonText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: AppColor.primaryColor,
                        onTap: () => userGroup[i].id == '22'
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
            }
          }
          return const Center();
        },
      ),
    );
  }
}

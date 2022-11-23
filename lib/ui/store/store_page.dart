import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/add_category_sheet.dart';
import 'package:viicsoft_inventory_app/component/confirm_delete_sheet.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/store_count_container.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/category.dart';
import 'package:viicsoft_inventory_app/models/equipments.dart';
import 'package:viicsoft_inventory_app/models/profile.dart';
import 'package:viicsoft_inventory_app/services/apis/category_api.dart';
import 'package:viicsoft_inventory_app/services/apis/equipment_api.dart';
import 'package:viicsoft_inventory_app/services/apis/user_api.dart';
import 'package:viicsoft_inventory_app/ui/store/equipment_page.dart';

class StorePage extends StatefulWidget {
  const StorePage({
    Key? key,
  }) : super(key: key);

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  Future refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColor.white,
          automaticallyImplyLeading: false,
          toolbarHeight: screensize.height * 0.12,
          title: Row(children: [
            Text(
              'Store',
              style: style.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Expanded(child: Container()),
            FutureBuilder<List<Groups>>(
              future: UserAPI().fetchUserGroup(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Center();
                  } else {
                    var userGroup = snapshot.data!;
                    for (var i = 0; i < userGroup.length; i++) {
                      return userGroup[i].id == '22'
                          ? TextButton(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add_circle_outline,
                                    color: AppColor.primaryColor,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'New Category',
                                    style: style.copyWith(fontSize: 14),
                                  )
                                ],
                              ),
                              onPressed: () {
                                // create category on click bottomsheet
                                showModalBottomSheet<int>(
                                  isScrollControlled: true,
                                  enableDrag: true,
                                  context: context,
                                  builder: (_) {
                                    return const CategorySheet();
                                  },
                                );
                              },
                            )
                          : Container();
                    }
                  }
                }
                return const Center();
              },
            )
          ]),
        ),
        backgroundColor: AppColor.homePageColor,
        body: RefreshIndicator(
          onRefresh: refresh,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ' EQUIPMENT CATEGORIES',
                  style: style.copyWith(color: AppColor.darkGrey),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: FutureBuilder<List<EquipmentCategory>>(
                    future: CategoryAPI().fetchAllCategory(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: CircularProgressIndicator(color: AppColor.red),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        final results = snapshot.data!;

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 5),
                          itemCount: results.length,
                          itemBuilder: (_, int index) {
                            return FutureBuilder<List<Groups>>(
                              future: UserAPI().fetchUserGroup(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasError) {
                                    return const Center();
                                  } else {
                                    var userGroup = snapshot.data!;
                                    for (var i = 0; i < userGroup.length; i++) {
                                      return InkWell(
                                        onLongPress: () async {
                                          if (userGroup[i].id == '22') {
                                            confirmDeleteSheet(
                                                context: context,
                                                blackbuttonText:
                                                    'No! MAKE I ASK OGA FESS',
                                                redbuttonText:
                                                    'YES! DELETE CATEGORY',
                                                title:
                                                    'Are you sure you want to permanently delete ( ${results[index].name} ) category',
                                                onTapBlackButton: () =>
                                                    Navigator.pop(context),
                                                onTapRedButton: () async {
                                                  var res = await CategoryAPI()
                                                      .deleteCategory(
                                                          results[index].id);
                                                  if (res.statusCode == 200) {
                                                    setState(() {});
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        backgroundColor:
                                                            Colors.green,
                                                        content: Text(
                                                            "${results[index].name} Category successfully deleted"),
                                                      ),
                                                    );
                                                    Navigator.pop(context);
                                                  }
                                                });
                                          }
                                        },
                                        child: SizedBox(
                                          height: 145,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            elevation: 0,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        results[index].name,
                                                        style: style.copyWith(
                                                          fontSize: 18,
                                                          color: AppColor.black,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Container(
                                                        width: 24,
                                                        height: 24,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            4,
                                                          ),
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  results[index]
                                                                      .image),
                                                              fit: BoxFit.fill),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                  const Divider(),
                                                  FutureBuilder<
                                                          List<
                                                              EquipmentElement>>(
                                                      future: EquipmentAPI()
                                                          .fetchAllEquipments(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return Container();
                                                        } else if (snapshot
                                                            .hasData) {
                                                          var equipResult =
                                                              snapshot.data!;
                                                          //
                                                          var categoryEquipmet =
                                                              equipResult
                                                                  .where((item) =>
                                                                      item.equipmentCategoryId ==
                                                                      results[index]
                                                                          .id)
                                                                  .toList();
                                                          //

                                                          var goodEquipment =
                                                              categoryEquipmet
                                                                  .where((item) =>
                                                                      item.equipmentCondition ==
                                                                          'NEW' ||
                                                                      item.equipmentCondition ==
                                                                          'OLD')
                                                                  .toList();
                                                          //
                                                          var fairEquipment =
                                                              categoryEquipmet
                                                                  .where((item) =>
                                                                      item.equipmentCondition ==
                                                                      'FAIR')
                                                                  .toList();

                                                          //
                                                          var badEquipment =
                                                              categoryEquipmet
                                                                  .where((item) =>
                                                                      item.equipmentCondition ==
                                                                      'BAD')
                                                                  .toList();
                                                          return Row(
                                                            children: [
                                                              StoreCount(
                                                                backgroundColor:
                                                                    const Color(
                                                                        0xffECF8FE),
                                                                textColor:
                                                                    const Color(
                                                                        0xff3EB8F9),
                                                                conditionName:
                                                                    '${categoryEquipmet.length} Items',
                                                              ),
                                                              //
                                                              const SizedBox(
                                                                width: 3,
                                                              ),
                                                              StoreCount(
                                                                backgroundColor:
                                                                    const Color(
                                                                        0xffEDF9F3),
                                                                textColor:
                                                                    const Color(
                                                                        0xff4BC187),
                                                                conditionName:
                                                                    '${goodEquipment.length} Good',
                                                              ),
                                                              //
                                                              const SizedBox(
                                                                width: 3,
                                                              ),
                                                              StoreCount(
                                                                backgroundColor:
                                                                    const Color(
                                                                        0xffFFFAEC),
                                                                textColor:
                                                                    const Color(
                                                                        0xffFFCC42),
                                                                conditionName:
                                                                    '${fairEquipment.length} Fair',
                                                              ),
                                                              //
                                                              const SizedBox(
                                                                width: 3,
                                                              ),
                                                              StoreCount(
                                                                backgroundColor:
                                                                    const Color(
                                                                        0xffFEEAEA),
                                                                textColor:
                                                                    const Color(
                                                                        0xffF22B29),
                                                                conditionName:
                                                                    '${badEquipment.length} Bad',
                                                              ),
                                                              Expanded(
                                                                  child:
                                                                      Container()),
                                                              InkWell(
                                                                onTap: () =>
                                                                    Navigator
                                                                        .push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) => EquipmentPage(
                                                                        equipmentCategory:
                                                                            results[
                                                                                index],
                                                                        categoryId:
                                                                            results[index].id),
                                                                  ),
                                                                ),
                                                                child: Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  color: AppColor
                                                                      .darkGrey,
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        }
                                                        return Container();
                                                      })
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                }
                                return Container();
                              },
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                              color: AppColor.darkGrey),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

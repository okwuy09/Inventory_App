import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viicsoft_inventory_app/component/add_category_sheet.dart';
import 'package:viicsoft_inventory_app/component/confirm_delete_sheet.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/store_count_container.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/category.dart';
import 'package:viicsoft_inventory_app/models/equipments.dart';
import 'package:viicsoft_inventory_app/services/provider/appdata.dart';
import 'package:viicsoft_inventory_app/services/provider/userdata.dart';
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
    var provider = Provider.of<AppData>(context);
    var priority = Provider.of<UserData>(context).userData.rolesPriority;
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
            priority == 'admin'
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
                      showModalBottomSheet(
                        isScrollControlled: true,
                        enableDrag: true,
                        context: context,
                        builder: (_) {
                          return const CategorySheet();
                        },
                      );
                    },
                  )
                : Container(),
          ]),
        ),
        backgroundColor: AppColor.homePageColor,
        body: Padding(
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
                child: StreamBuilder<List<EquipmentCategory>>(
                  stream: provider.fetchAllEquipmentCategory(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return pageCircularIndicator;
                    } else {
                      final results = snapshot.data!;
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        itemCount: results.length,
                        itemBuilder: (_, int index) {
                          return InkWell(
                            onLongPress: () async {
                              if (Provider.of<UserData>(context, listen: false)
                                      .userData
                                      .rolesPriority ==
                                  'admin') {
                                confirmDeleteSheet(
                                    context: context,
                                    blackbuttonText: 'No! MAKE I ASK OGA FESS',
                                    redbuttonText: 'YES! DELETE CATEGORY',
                                    title:
                                        'Are you sure you want to permanently delete ( ${results[index].name} ) category',
                                    onTapBlackButton: () =>
                                        Navigator.pop(context),
                                    onTapRedButton: () async {
                                      await provider.deleteCategory(
                                          results[index].id, context);
                                    });
                              }
                            },
                            child: SizedBox(
                              height: 145,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
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
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                4,
                                              ),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    results[index].image),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      const Divider(),
                                      StreamBuilder<List<EquipmentElement>>(
                                          stream: provider.fetchAllEquipment(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              var equipResult = snapshot.data!;
                                              //
                                              var categoryEquipmet = equipResult
                                                  .where((item) =>
                                                      item.equipmentCategoryId ==
                                                      results[index].id)
                                                  .toList();
                                              //

                                              var goodEquipment = categoryEquipmet
                                                  .where((item) =>
                                                      item.equipmentCondition ==
                                                          'NEW' ||
                                                      item.equipmentCondition ==
                                                          'OLD')
                                                  .toList();
                                              //
                                              var fairEquipment = categoryEquipmet
                                                  .where((item) =>
                                                      item.equipmentCondition ==
                                                      'FAIR')
                                                  .toList();

                                              //
                                              var badEquipment = categoryEquipmet
                                                  .where((item) =>
                                                      item.equipmentCondition ==
                                                      'BAD')
                                                  .toList();
                                              return Row(
                                                children: [
                                                  StoreCount(
                                                    backgroundColor:
                                                        const Color(0xffECF8FE),
                                                    textColor:
                                                        const Color(0xff3EB8F9),
                                                    conditionName:
                                                        '${categoryEquipmet.length} Items',
                                                  ),
                                                  //
                                                  const SizedBox(
                                                    width: 3,
                                                  ),
                                                  StoreCount(
                                                    backgroundColor:
                                                        const Color(0xffEDF9F3),
                                                    textColor:
                                                        const Color(0xff4BC187),
                                                    conditionName:
                                                        '${goodEquipment.length} Good',
                                                  ),
                                                  //
                                                  const SizedBox(
                                                    width: 3,
                                                  ),
                                                  StoreCount(
                                                    backgroundColor:
                                                        const Color(0xffFFFAEC),
                                                    textColor:
                                                        const Color(0xffFFCC42),
                                                    conditionName:
                                                        '${fairEquipment.length} Fair',
                                                  ),
                                                  //
                                                  const SizedBox(
                                                    width: 3,
                                                  ),
                                                  StoreCount(
                                                    backgroundColor:
                                                        const Color(0xffFEEAEA),
                                                    textColor:
                                                        const Color(0xffF22B29),
                                                    conditionName:
                                                        '${badEquipment.length} Bad',
                                                  ),
                                                  Expanded(child: Container()),
                                                  InkWell(
                                                    onTap: () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            EquipmentPage(
                                                                equipmentCategory:
                                                                    results[
                                                                        index],
                                                                categoryId:
                                                                    results[index]
                                                                        .id),
                                                      ),
                                                    ),
                                                    child: Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: AppColor.darkGrey,
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
                        },
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

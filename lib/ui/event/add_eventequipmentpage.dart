import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/button.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/avialable_equipment.dart';
import 'package:viicsoft_inventory_app/models/category.dart';
import 'package:viicsoft_inventory_app/services/apis/category_api.dart';
import 'package:viicsoft_inventory_app/services/apis/equipment_api.dart';
import 'package:viicsoft_inventory_app/services/apis/event_api.dart';

// ignore: must_be_immutable
class AddEventEquipmentPage extends StatefulWidget {
  String eventId;
  String eventName;
  AddEventEquipmentPage(
      {Key? key, required this.eventId, required this.eventName})
      : super(key: key);

  @override
  State<AddEventEquipmentPage> createState() => _AddEventEquipmentPageState();
}

class _AddEventEquipmentPageState extends State<AddEventEquipmentPage> {
  EquipmentCategory? selectedCategory;
  final CategoryAPI _categoryApi = CategoryAPI();
  final EquipmentAPI _equipmentAPI = EquipmentAPI();
  late Future<List<EquipmentCategory>> _category;
  late Future equipmentFuture;
  int? selectedIndex;
  List selectedEquipment = [];

  @override
  void initState() {
    super.initState();
    _category = _categoryApi.fetchAllCategory();
  }

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.homePageColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.white,
        toolbarHeight: screensize.height * 0.1,
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
            Text(widget.eventName, style: style),
            Expanded(child: Container()),
          ],
        ),
      ),
      body: FutureBuilder<List<EquipmentCategory>>(
          future: _category,
          builder: (context, snapshot) {
            final category = snapshot.data;
            if (category != null) {
              return Column(
                children: [
                  Container(
                    color: AppColor.lightGrey,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 25),
                    height: 140,
                    child: Column(
                      children: [
                        DropdownButton<EquipmentCategory>(
                          isExpanded: true,
                          value: selectedCategory ?? category[0],
                          elevation: 16,
                          style: TextStyle(color: Colors.grey[600]),
                          onChanged: (newValue) {
                            setState(() {
                              selectedCategory = newValue!;
                            });
                          },
                          items: category.map((EquipmentCategory value) {
                            return DropdownMenuItem<EquipmentCategory>(
                              value: value,
                              child: Text(
                                value.name,
                                style: TextStyle(
                                    color: AppColor.primaryColor, fontSize: 20),
                              ),
                            );
                          }).toList(),
                        ),
                        Center(
                          child: Text(
                            'Select category  and Add equipment to the Event',
                            style: style.copyWith(
                              fontSize: 12,
                              color: AppColor.darkGrey,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screensize.height * 0.56,
                    child: FutureBuilder<List<EquipmentsAvailable>>(
                        future: _equipmentAPI.fetchAvialableEquipments(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (selectedCategory == null) {
                              return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (_, index) {
                                    return equipmentCard(screensize,
                                        snapshot.data!, index, context);
                                  });
                            } else {
                              final results = snapshot.data!;
                              var result = results
                                  .where((item) => selectedCategory!.id
                                      .contains(item.equipmentCategoryId))
                                  .toList();
                              return ListView.builder(
                                itemCount: result.length,
                                itemBuilder: (_, int index) {
                                  return equipmentCard(
                                      screensize, result, index, context);
                                },
                              );
                            }
                          } else {
                            return const Center();
                          }
                        }),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 20, left: 20, top: 20),
                    child: MainButton(
                      borderColor: Colors.transparent,
                      child: Text(
                        'CONTINUE',
                        style: style.copyWith(
                          fontSize: 14,
                          color: AppColor.buttonText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: AppColor.primaryColor,
                      onTap: () => {
                        Navigator.pop(context),
                        setState(() {}),
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Center();
            }
          }),
    );
  }

  Padding equipmentCard(Size screensize, List<EquipmentsAvailable> result,
      int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: SizedBox(
        height: 85,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 3, left: 5, bottom: 3, right: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            image: DecorationImage(
                              image: NetworkImage(result[index].equipmentImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      result[index].equipmentName,
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: AppColor.homePageTitle,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      height: 30,
                                      width: 52,
                                      decoration: BoxDecoration(
                                          color: result[index]
                                                      .equipmentCondition ==
                                                  'BAD'
                                              ? const Color(0xFFFEEAEA)
                                              : result[index].equipmentCondition ==
                                                          'NEW' ||
                                                      result[index]
                                                              .equipmentCondition ==
                                                          'OLD'
                                                  ? const Color(0xFFEDF9F3)
                                                  : result[index]
                                                              .equipmentCondition ==
                                                          'FAIR'
                                                      ? const Color(0xFFFFFAEC)
                                                      : null,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Center(
                                        child: Text(
                                          result[index].equipmentCondition ==
                                                  'BAD'
                                              ? 'Bad'
                                              : result[index].equipmentCondition ==
                                                          'NEW' ||
                                                      result[index]
                                                              .equipmentCondition ==
                                                          'OLD'
                                                  ? 'Good'
                                                  : result[index]
                                                              .equipmentCondition ==
                                                          'FAIR'
                                                      ? 'Fair'
                                                      : '',
                                          style: style.copyWith(
                                            fontSize: 12,
                                            color: result[index]
                                                        .equipmentCondition ==
                                                    'BAD'
                                                ? AppColor.red
                                                : result[index].equipmentCondition ==
                                                            'NEW' ||
                                                        result[index]
                                                                .equipmentCondition ==
                                                            'OLD'
                                                    ? AppColor.green
                                                    : result[index]
                                                                .equipmentCondition ==
                                                            'FAIR'
                                                        ? const Color(
                                                            0xFFFFCC42)
                                                        : null,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                    IconButton(
                                        onPressed: () async {
                                          var res = await EventAPI()
                                              .addEventEquipment(widget.eventId,
                                                  result[index].equipmentId);
                                          if (res.statusCode == 200 &&
                                              selectedEquipment.contains(
                                                  result[index].equipmentId)) {
                                            setState(() {
                                              selectedEquipment.remove(
                                                  result[index].equipmentId);
                                            });
                                          } else {
                                            setState(() {
                                              selectedEquipment.add(
                                                  result[index].equipmentId);
                                            });
                                          }
                                        },
                                        icon: selectedEquipment.contains(
                                                result[index].equipmentId)
                                            ? Icon(Icons.check_box_outlined,
                                                color: AppColor.green)
                                            : Icon(
                                                Icons.check_box_outline_blank,
                                                color: AppColor.darkGrey)),
                                  ],
                                )
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
    );
  }
}

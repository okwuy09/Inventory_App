import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/category.dart';
import 'package:viicsoft_inventory_app/models/equipment_not_avialable.dart';
import 'package:viicsoft_inventory_app/services/apis/category_api.dart';
import 'package:viicsoft_inventory_app/services/apis/equipment_api.dart';

// ignore: must_be_immutable
class EquipmentNotAvialablePage extends StatefulWidget {
  const EquipmentNotAvialablePage({Key? key}) : super(key: key);

  @override
  State<EquipmentNotAvialablePage> createState() =>
      _EquipmentNotAvialablePageState();
}

class _EquipmentNotAvialablePageState extends State<EquipmentNotAvialablePage> {
  EquipmentCategory? selectedCategory;
  final CategoryAPI _categoryApi = CategoryAPI();
  late Future<List<EquipmentCategory>> _category;
  late Future equipmentFuture;
  List selectedEquipment = [];

  @override
  void initState() {
    super.initState();
    _category = _categoryApi.fetchAllCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.homePageColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 75,
        backgroundColor: AppColor.white,
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
            Text('Equipment Not Avialable',
                style: style.copyWith(fontWeight: FontWeight.bold)),
            Expanded(child: Container()),
          ],
        ),
      ),
      body: FutureBuilder<List<EquipmentCategory>>(
          future: _category,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
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
                                    style: style.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.red,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            Center(
                              child: Text(
                                'Select category to display equipment',
                                style: style.copyWith(
                                    fontSize: 11, color: AppColor.darkGrey),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: FutureBuilder<
                                List<EquipmentsNotAvailableElement>>(
                            future:
                                EquipmentAPI().fetchEquipmentsNotAvialable(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (selectedCategory == null) {
                                  return ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (_, int index) {
                                        return equipmentCard(
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
                                          result, index, context);
                                    },
                                  );
                                }
                              } else {
                                return const Center();
                              }
                            }),
                      )
                    ],
                  );
                } else {
                  return const Center();
                }
              }
            }
            return Center(
              child: CircularProgressIndicator(color: AppColor.darkGrey),
            );
          }),
    );
  }

  Padding equipmentCard(List<EquipmentsNotAvailableElement> result, int index,
      BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: SizedBox(
        height: 85,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 3,
              left: 6,
            ),
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
                            borderRadius: BorderRadius.circular(10),
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
                                Text(
                                  result[index].equipmentName,
                                  maxLines: 1,
                                  style: style.copyWith(fontSize: 14),
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
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Column(
                                        children: [
                                          Text(
                                            'CheckOut Date',
                                            style: style.copyWith(
                                              fontSize: 8,
                                              color: AppColor.darkGrey,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            '${result[index].checkoutDate.day}-${result[index].checkoutDate.month}-${result[index].checkoutDate.year}',
                                            style: style.copyWith(
                                              fontSize: 8,
                                              color: AppColor.darkGrey,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Text('Event:   ${result[index].eventName}',
                                maxLines: 2,
                                style: style.copyWith(
                                    fontSize: 11, color: AppColor.darkGrey)),
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

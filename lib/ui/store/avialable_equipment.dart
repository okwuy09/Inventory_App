// ignore: file_names
import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/avialable_equipment.dart';
import 'package:viicsoft_inventory_app/models/category.dart';
import 'package:viicsoft_inventory_app/services/apis/category_api.dart';
import 'package:viicsoft_inventory_app/services/apis/equipment_api.dart';

// ignore: must_be_immutable
class AvialableEquipmentPage extends StatefulWidget {
  const AvialableEquipmentPage({Key? key}) : super(key: key);

  @override
  State<AvialableEquipmentPage> createState() => _AvialableEquipmentPageState();
}

class _AvialableEquipmentPageState extends State<AvialableEquipmentPage> {
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
        elevation: 0,
        backgroundColor: AppColor.white,
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
            Text(
              'Avialable Equipments',
              style: style.copyWith(fontWeight: FontWeight.bold),
            ),
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
                              style: TextStyle(color: AppColor.lightGrey),
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
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: AppColor.green),
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
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: FutureBuilder<List<EquipmentsAvailable>>(
                            future: EquipmentAPI().fetchAvialableEquipments(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (selectedCategory == null) {
                                  final result = snapshot.data!;
                                  return SizedBox(
                                    child: ListView.builder(
                                      itemCount: result.length,
                                      itemBuilder: (_, int index) {
                                        return equipmentCard(
                                            result, index, context);
                                      },
                                    ),
                                  );
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

  equipmentCard(
      List<EquipmentsAvailable> result, int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: SizedBox(
        height: 80,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(6),
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
                          Text(result[index].equipmentName,
                              maxLines: 1, style: style.copyWith(fontSize: 14)),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.all(4),
                            height: 30,
                            width: 52,
                            decoration: BoxDecoration(
                                color: result[index].equipmentCondition == 'BAD'
                                    ? const Color(0xFFFEEAEA)
                                    : result[index].equipmentCondition ==
                                                'NEW' ||
                                            result[index].equipmentCondition ==
                                                'OLD'
                                        ? const Color(0xFFEDF9F3)
                                        : result[index].equipmentCondition ==
                                                'FAIR'
                                            ? const Color(0xFFFFFAEC)
                                            : null,
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                              child: Text(
                                result[index].equipmentCondition == 'BAD'
                                    ? 'Bad'
                                    : result[index].equipmentCondition ==
                                                'NEW' ||
                                            result[index].equipmentCondition ==
                                                'OLD'
                                        ? 'Good'
                                        : result[index].equipmentCondition ==
                                                'FAIR'
                                            ? 'Fair'
                                            : '',
                                style: style.copyWith(
                                  fontSize: 12,
                                  color: result[index].equipmentCondition ==
                                          'BAD'
                                      ? AppColor.red
                                      : result[index].equipmentCondition ==
                                                  'NEW' ||
                                              result[index]
                                                      .equipmentCondition ==
                                                  'OLD'
                                          ? AppColor.green
                                          : result[index].equipmentCondition ==
                                                  'FAIR'
                                              ? const Color(0xFFFFCC42)
                                              : null,
                                ),
                              ),
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

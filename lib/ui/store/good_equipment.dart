import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/equip_cond_sheet.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/category.dart';
import 'package:viicsoft_inventory_app/models/equipments.dart';
import 'package:viicsoft_inventory_app/services/provider/appdata.dart';

// ignore: must_be_immutable
class GoodEquipmentPage extends StatefulWidget {
  final List<EquipmentElement> equipment;
  const GoodEquipmentPage({Key? key, required this.equipment})
      : super(key: key);

  @override
  State<GoodEquipmentPage> createState() => _GoodEquipmentPageState();
}

class _GoodEquipmentPageState extends State<GoodEquipmentPage> {
  EquipmentCategory? selectedCategory;
  late Stream<List<EquipmentCategory>> _category;

  @override
  void initState() {
    super.initState();
    _category = Provider.of<AppData>(context, listen: false)
        .fetchAllEquipmentCategory();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.homePageColor,
      body: StreamBuilder<List<EquipmentCategory>>(
          stream: _category,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final category = snapshot.data;
              if (category != null) {
                return Column(
                  children: [
                    Container(
                      height: 220,
                      padding: const EdgeInsets.only(top: 50),
                      color: const Color(0xFFEDF9F3),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 21.75,
                                ),
                              ),
                              Expanded(child: Container()),
                              Text('Good Equipments', style: style),
                              const SizedBox(width: 50),
                              Expanded(child: Container()),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 25),
                            height: 110,
                            child: Column(
                              children: [
                                DropdownButton<EquipmentCategory>(
                                  dropdownColor: const Color(0xFFEDF9F3),
                                  isExpanded: true,
                                  value: selectedCategory ?? category[0],
                                  elevation: 16,
                                  style: style.copyWith(fontSize: 12),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedCategory = newValue!;
                                    });
                                  },
                                  items:
                                      category.map((EquipmentCategory value) {
                                    return DropdownMenuItem<EquipmentCategory>(
                                      value: value,
                                      child: Text(value.name,
                                          style: style.copyWith(
                                              color: const Color(0xFF4BC187),
                                              fontSize: 18)),
                                    );
                                  }).toList(),
                                ),
                                Center(
                                  child: Text(
                                    'Select category to display equipment',
                                    style: style.copyWith(
                                      fontSize: 12,
                                      color: AppColor.darkGrey,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenSize.height * 0.7,
                      child: Builder(builder: (context) {
                        if (selectedCategory == null) {
                          return SizedBox(
                            child: MediaQuery.removePadding(
                              removeTop: true,
                              context: context,
                              child: ListView.builder(
                                itemCount: widget.equipment.length,
                                itemBuilder: (_, int index) {
                                  return equipmentCard(
                                    widget.equipment,
                                    index,
                                    context,
                                  );
                                },
                              ),
                            ),
                          );
                        } else {
                          final results = widget.equipment;
                          var result = results
                              .where((item) => selectedCategory!.id
                                  .contains(item.equipmentCategoryId))
                              .toList();
                          return MediaQuery.removePadding(
                            removeTop: true,
                            context: context,
                            child: ListView.builder(
                              itemCount: result.length,
                              itemBuilder: (_, int index) {
                                return equipmentCard(result, index, context);
                              },
                            ),
                          );
                        }
                      }),
                    )
                  ],
                );
              } else {
                return const Center();
              }
            }
            return pageCircularIndicator;
          }),
    );
  }

  Padding equipmentCard(
      List<EquipmentElement> result, int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 15),
      child: SizedBox(
        height: 82,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 6, left: 6, bottom: 6),
            child: Row(
              children: [
                Container(
                  width: 57,
                  height: 57,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                      image: NetworkImage(result[index].equipmentImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        result[index].equipmentName,
                        maxLines: 1,
                        style: TextStyle(
                            color: AppColor.homePageTitle,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.62,
                          ),
                          InkWell(
                            onTap: () {
                              equipmentConditionbuttomSheet(
                                context,
                                result[index].equipmentImage,
                                result[index].equipmentName,
                                result[index].equipmentDescription!,
                                'Good',
                                const Color(0xFFEDF9F3),
                                const Color(0xFF4BC187),
                              );
                            },
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 21.75,
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
          ),
        ),
      ),
    );
  }
}

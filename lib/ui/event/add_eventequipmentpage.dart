import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viicsoft_inventory_app/component/button.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/category.dart';
import 'package:viicsoft_inventory_app/models/equipments.dart';
import 'package:viicsoft_inventory_app/models/events.dart';
import 'package:viicsoft_inventory_app/services/provider/appdata.dart';

// ignore: must_be_immutable
class AddEventEquipmentPage extends StatefulWidget {
  Event event;
  AddEventEquipmentPage({Key? key, required this.event}) : super(key: key);

  @override
  State<AddEventEquipmentPage> createState() => _AddEventEquipmentPageState();
}

class _AddEventEquipmentPageState extends State<AddEventEquipmentPage> {
  EquipmentCategory? selectedCategory;
  late Stream<List<EquipmentCategory>> _category;
  late Future equipmentFuture;
  int? selectedIndex;
  List selectedEquipment = [];

  @override
  void initState() {
    super.initState();
    _category = Provider.of<AppData>(context, listen: false)
        .fetchAllEquipmentCategory();
  }

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    var provider = Provider.of<AppData>(context);
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
            Text(widget.event.eventName, style: style),
            Expanded(child: Container()),
          ],
        ),
      ),
      body: StreamBuilder<List<Event>>(
        stream: provider.fetchAllEvent(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return pageCircularIndicator;
          } else {
            var event = snapshot.data!
                .where((item) => item.id == widget.event.id)
                .toList();
            return StreamBuilder<List<EquipmentCategory>>(
              stream: _category,
              builder: (context, snapshot) {
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
                                      style: TextStyle(
                                          color: AppColor.primaryColor,
                                          fontSize: 20),
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
                          child: StreamBuilder<List<EquipmentElement>>(
                              stream: provider.fetchAllEquipment(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final result = snapshot.data!;
                                  var results = result
                                      .where((item) =>
                                          item.isEquipmentAvialable == true)
                                      .toList();
                                  if (selectedCategory == null) {
                                    return ListView.builder(
                                        itemCount: results.length,
                                        itemBuilder: (_, index) {
                                          return equipmentCard(
                                            screensize,
                                            results,
                                            index,
                                            context,
                                            provider,
                                            event[0],
                                          );
                                        });
                                  } else {
                                    var newResult = results
                                        .where((item) => selectedCategory!.id
                                            .contains(item.equipmentCategoryId))
                                        .toList();
                                    return ListView.builder(
                                      itemCount: newResult.length,
                                      itemBuilder: (_, int index) {
                                        return equipmentCard(
                                          screensize,
                                          newResult,
                                          index,
                                          context,
                                          provider,
                                          event[0],
                                        );
                                      },
                                    );
                                  }
                                }
                                return pageCircularIndicator;
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 20, left: 20, top: 20),
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
                }
                return pageCircularIndicator;
              },
            );
          }
        },
      ),
    );
  }

  Padding equipmentCard(Size screensize, List<EquipmentElement> result,
      int index, BuildContext context, AppData provider, Event event) {
    var eventEquipment = List<String>.generate(event.eventEquipment.length,
        (i) => event.eventEquipment[i].equipmentId).toList();
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
                                          await provider.addEventEquipment(
                                            equipmentId: result[index].id,
                                            ischeckedOut: false,
                                            eventId: event.id,
                                            context: context,
                                          );
                                        },
                                        icon: eventEquipment
                                                .contains(result[index].id)
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

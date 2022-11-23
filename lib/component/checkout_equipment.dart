import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/confirm_delete_sheet.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/eventequipmentcheckout.dart';
import 'package:viicsoft_inventory_app/models/events.dart';
import 'package:viicsoft_inventory_app/models/profile.dart';
import 'package:viicsoft_inventory_app/services/apis/equipment_checkout_api.dart';
import 'package:viicsoft_inventory_app/services/apis/user_api.dart';

handleCheckoutEquipment({context, Event? events}) {
  return showModalBottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return CheckOutEquipment(events: events);
      });
}

class CheckOutEquipment extends StatefulWidget {
  final Event? events;
  const CheckOutEquipment({Key? key, this.events}) : super(key: key);

  @override
  State<CheckOutEquipment> createState() => _CheckOutEquipmentState();
}

class _CheckOutEquipmentState extends State<CheckOutEquipment> {
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.homePageColor,
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          Container(
            height: 170,
            color: AppColor.white,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.25,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 12.0,
                      ),
                      child: Container(
                        height: 5.0,
                        decoration: BoxDecoration(
                          color: AppColor.darkGrey,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(2.5)),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 20, left: 20, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.events!.eventName,
                        style: style.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(4),
                        height: 38,
                        width: 122,
                        decoration: BoxDecoration(
                            color: DateTime.now()
                                    .isAfter(widget.events!.checkInDate)
                                ? AppColor.lightGrey
                                : widget.events!.checkOutDate
                                            .isBefore(DateTime.now()) &&
                                        widget.events!.checkInDate
                                            .isAfter(DateTime.now())
                                    ? const Color(0xFFEDF9F3)
                                    : DateTime.now().isBefore(
                                            widget.events!.checkOutDate)
                                        ? const Color(0xFFFFFAEC)
                                        : null,
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Text(
                            DateTime.now().isAfter(widget.events!.checkInDate)
                                ? 'Ended'
                                : widget.events!.checkOutDate
                                            .isBefore(DateTime.now()) &&
                                        widget.events!.checkInDate
                                            .isAfter(DateTime.now())
                                    ? 'Ongoing'
                                    : DateTime.now().isBefore(
                                            widget.events!.checkOutDate)
                                        ? 'Not Started Yet'
                                        : '',
                            style: style.copyWith(
                              fontSize: 12,
                              color: DateTime.now()
                                      .isAfter(widget.events!.checkInDate)
                                  ? AppColor.darkGrey
                                  : widget.events!.checkOutDate
                                              .isBefore(DateTime.now()) &&
                                          widget.events!.checkInDate
                                              .isAfter(DateTime.now())
                                      ? AppColor.green
                                      : DateTime.now().isBefore(
                                              widget.events!.checkOutDate)
                                          ? const Color(0xFFFFCC42)
                                          : null,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date:  ${widget.events!.checkOutDate.day}th ${months[widget.events!.checkOutDate.month - 1]}",
                            style: style.copyWith(
                              color: AppColor.darkGrey,
                            ),
                          ),
                          Text(
                            " -  ${widget.events!.checkInDate.day}th ${months[widget.events!.checkInDate.month - 1]}, ${widget.events!.checkInDate.year}",
                            style: style.copyWith(
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
          FutureBuilder<List<EventsEquipmentCheckout>>(
            future: EquipmentCheckOutAPI().fetchAllEquipmentCheckOut(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: AppColor.darkGrey),
                );
              }

              if (snapshot.hasData) {
                var checkoutEquipments = snapshot.data!;
                var result = checkoutEquipments
                    .where((element) => element.eventId == widget.events!.id)
                    .toList();
                return Expanded(
                  child: ListView.builder(
                    itemCount: result.length,
                    itemBuilder: (_, int index) {
                      return Container(
                        color: AppColor.homePageColor,
                        child: Column(
                          children: [
                            const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 20,
                                left: 20,
                              ),
                              child: FutureBuilder<List<Groups>>(
                                future: UserAPI().fetchUserGroup(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasError) {
                                      return const Center();
                                    } else {
                                      var userGroup = snapshot.data!;
                                      for (var i = 0;
                                          i < userGroup.length;
                                          i++) {
                                        return InkWell(
                                          onLongPress: () {
                                            if (userGroup[i].id == '22') {
                                              confirmDeleteSheet(
                                                  context: context,
                                                  title:
                                                      'Are you sure you want to remove (${result[index].equipment.equipmentName}) from check out list',
                                                  blackbuttonText:
                                                      'No! MAKE I ASK OGA FESS',
                                                  redbuttonText:
                                                      'YES! REMOVE EQUIPMENT',
                                                  onTapBlackButton: () =>
                                                      Navigator.pop(context),
                                                  onTapRedButton: () async {
                                                    var res =
                                                        await EquipmentCheckOutAPI()
                                                            .deleteEventEquipmentCheckout(
                                                                result[index]
                                                                    .id);
                                                    if (res.statusCode == 200) {
                                                      setState(() {});
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          backgroundColor:
                                                              Colors.green,
                                                          content: Text(
                                                            "(${result[index].equipment.equipmentName})  Equipment successfully removed",
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  });
                                            }
                                          },
                                          child: SizedBox(
                                            height: 80,
                                            child: Card(
                                              color: AppColor.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              elevation: 0,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 6,
                                                  left: 5,
                                                  right: 3,
                                                  bottom: 5,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 56,
                                                      height: 56,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              result[index]
                                                                  .equipment
                                                                  .equipmentImage),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  result[index]
                                                                      .equipment
                                                                      .equipmentName,
                                                                  maxLines: 1,
                                                                  style: style
                                                                      .copyWith(
                                                                          fontSize:
                                                                              14),
                                                                ),
                                                                const SizedBox(
                                                                    height: 5),
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              4),
                                                                      height:
                                                                          30,
                                                                      width: 52,
                                                                      decoration: BoxDecoration(
                                                                          color: result[index].equipment.equipmentCondition == 'BAD'
                                                                              ? const Color(0xFFFEEAEA)
                                                                              : result[index].equipment.equipmentCondition == 'NEW' || result[index].equipment.equipmentCondition == 'OLD'
                                                                                  ? const Color(0xFFEDF9F3)
                                                                                  : result[index].equipment.equipmentCondition == 'FAIR'
                                                                                      ? const Color(0xFFFFFAEC)
                                                                                      : null,
                                                                          borderRadius: BorderRadius.circular(8)),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          result[index].equipment.equipmentCondition == 'BAD'
                                                                              ? 'Bad'
                                                                              : result[index].equipment.equipmentCondition == 'NEW' || result[index].equipment.equipmentCondition == 'OLD'
                                                                                  ? 'Good'
                                                                                  : result[index].equipment.equipmentCondition == 'FAIR'
                                                                                      ? 'Fair'
                                                                                      : '',
                                                                          style:
                                                                              style.copyWith(
                                                                            fontSize:
                                                                                12,
                                                                            color: result[index].equipment.equipmentCondition == 'BAD'
                                                                                ? AppColor.red
                                                                                : result[index].equipment.equipmentCondition == 'NEW' || result[index].equipment.equipmentCondition == 'OLD'
                                                                                    ? AppColor.green
                                                                                    : result[index].equipment.equipmentCondition == 'FAIR'
                                                                                        ? const Color(0xFFFFCC42)
                                                                                        : null,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                        child:
                                                                            Container()),
                                                                    result[index].isReturned ==
                                                                            '1'
                                                                        ? Text(
                                                                            'Checked In',
                                                                            style:
                                                                                style.copyWith(fontSize: 8, color: AppColor.green),
                                                                          )
                                                                        : Text(
                                                                            'Not Checked In',
                                                                            style:
                                                                                style.copyWith(fontSize: 8, color: AppColor.red),
                                                                          ),
                                                                    const SizedBox(
                                                                      width: 10,
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
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                  return const Center();
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
              return const Center();
            },
          ),
        ],
      ),
    );
  }
}

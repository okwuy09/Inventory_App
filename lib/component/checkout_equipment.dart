import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/confirm_delete_sheet.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/eventequipmentcheckout.dart';
import 'package:viicsoft_inventory_app/models/events.dart';
import 'package:viicsoft_inventory_app/services/provider/appdata.dart';
import 'package:viicsoft_inventory_app/services/provider/userdata.dart';

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
    var provider = Provider.of<AppData>(context);

    var priority = Provider.of<UserData>(context).userData.rolesPriority;
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
                          fontSize: 18,
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
                          RichText(
                            text: TextSpan(
                              text: 'Date:  ',
                              style: style.copyWith(
                                color: AppColor.primaryColor,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      '${widget.events!.checkOutDate.day}th ${months[widget.events!.checkOutDate.month - 1]}',
                                  style: style.copyWith(
                                      fontSize: 12, color: AppColor.darkGrey),
                                ),
                                TextSpan(
                                  text:
                                      '  -  ${widget.events!.checkInDate.day} ${months[widget.events!.checkInDate.month - 1]}, ${widget.events!.checkInDate.year}',
                                  style: style.copyWith(
                                      fontSize: 12, color: AppColor.darkGrey),
                                ),
                              ],
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
          StreamBuilder<List<EventsEquipmentCheckout>>(
            stream: provider.fetchAllCheckOutEquipment(),
            builder: (context, snapshot) {
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
                              child: InkWell(
                                onLongPress: () {
                                  if (priority == 'admin') {
                                    confirmDeleteSheet(
                                        context: context,
                                        title:
                                            'Are you sure you want to remove (${result[index].equipmentName}) from check out list',
                                        blackbuttonText:
                                            'No! MAKE I ASK OGA FESS',
                                        redbuttonText: 'YES! REMOVE EQUIPMENT',
                                        onTapBlackButton: () =>
                                            Navigator.pop(context),
                                        onTapRedButton: () async {
                                          await provider
                                              .deleteCheckOutEquipment(
                                            result[index].id,
                                            context,
                                          );
                                        });
                                  }
                                },
                                child: SizedBox(
                                  height: 93,
                                  child: Card(
                                    color: AppColor.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
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
                                                  BorderRadius.circular(4),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    result[index]
                                                        .equipmentImage),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        result[index]
                                                            .equipmentName,
                                                        maxLines: 1,
                                                        style: style.copyWith(
                                                            fontSize: 14),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            height: 30,
                                                            width: 52,
                                                            decoration: BoxDecoration(
                                                                color: result[index].equipmentCondition == 'BAD'
                                                                    ? const Color(0xFFFEEAEA)
                                                                    : result[index].equipmentCondition == 'NEW' || result[index].equipmentCondition == 'OLD'
                                                                        ? const Color(0xFFEDF9F3)
                                                                        : result[index].equipmentCondition == 'FAIR'
                                                                            ? const Color(0xFFFFFAEC)
                                                                            : null,
                                                                borderRadius: BorderRadius.circular(8)),
                                                            child: Center(
                                                              child: Text(
                                                                result[index]
                                                                            .equipmentCondition ==
                                                                        'BAD'
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
                                                                style: style
                                                                    .copyWith(
                                                                  fontSize: 12,
                                                                  color: result[index]
                                                                              .equipmentCondition ==
                                                                          'BAD'
                                                                      ? AppColor
                                                                          .red
                                                                      : result[index].equipmentCondition == 'NEW' ||
                                                                              result[index].equipmentCondition ==
                                                                                  'OLD'
                                                                          ? AppColor
                                                                              .green
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
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              result[index]
                                                                      .isReturned
                                                                  ? Text(
                                                                      'Checked In',
                                                                      style: style.copyWith(
                                                                          fontSize:
                                                                              10,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              AppColor.green),
                                                                    )
                                                                  : Text(
                                                                      'Checked Out',
                                                                      style: style.copyWith(
                                                                          fontSize:
                                                                              10,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              AppColor.red),
                                                                    ),
                                                              const SizedBox(
                                                                  height: 4),
                                                              RichText(
                                                                text: TextSpan(
                                                                  text: 'By:  ',
                                                                  style: style.copyWith(
                                                                      fontSize:
                                                                          11,
                                                                      color: AppColor
                                                                          .primaryColor),
                                                                  children: [
                                                                    TextSpan(
                                                                      text: result[
                                                                              index]
                                                                          .checkOutUserName,
                                                                      style: style.copyWith(
                                                                          fontSize:
                                                                              10,
                                                                          color:
                                                                              AppColor.darkGrey),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              //
                                                              const SizedBox(
                                                                  height: 3),
                                                              RichText(
                                                                text: TextSpan(
                                                                  text:
                                                                      'Date:  ',
                                                                  style: style
                                                                      .copyWith(
                                                                    fontSize:
                                                                        11,
                                                                    color: AppColor
                                                                        .primaryColor,
                                                                  ),
                                                                  children: [
                                                                    TextSpan(
                                                                      text:
                                                                          '${result[index].equipmentOutDatetime.day}th ${months[result[index].equipmentOutDatetime.month - 1]}, ${result[index].equipmentOutDatetime.year}',
                                                                      style: style.copyWith(
                                                                          fontSize:
                                                                              9,
                                                                          color:
                                                                              AppColor.darkGrey),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              width: 10),
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
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
              return pageCircularIndicator;
            },
          ),
        ],
      ),
    );
  }
}

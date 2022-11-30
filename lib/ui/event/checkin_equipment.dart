import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/confirm_delete_sheet.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/equipmentcheckin.dart';
import 'package:viicsoft_inventory_app/services/provider/appdata.dart';
import 'package:viicsoft_inventory_app/services/provider/userdata.dart';

// ignore: must_be_immutable
class CheckInEquipmentPage extends StatefulWidget {
  const CheckInEquipmentPage({Key? key}) : super(key: key);

  @override
  State<CheckInEquipmentPage> createState() => _CheckInEquipmentPageState();
}

class _CheckInEquipmentPageState extends State<CheckInEquipmentPage> {
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
    return Scaffold(
      backgroundColor: AppColor.homePageColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.white,
        elevation: 0,
        toolbarHeight: 75,
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
            const SizedBox(height: 16),
            Text('CheckIn Equipment',
                style: style.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(width: MediaQuery.of(context).size.width * 0.15),
            Expanded(child: Container()),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<List<EventsEquipmentCheckIn>>(
              stream: provider.fetchAllCheckinEquipment(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return pageCircularIndicator;
                } else {
                  var result = snapshot.data!;
                  return MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: ListView.builder(
                      itemCount: result.length,
                      itemBuilder: (_, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 20, left: 20),
                          child: InkWell(
                            onLongPress: () async => {
                              if (priority == 'admin')
                                {
                                  confirmDeleteSheet(
                                      context: context,
                                      blackbuttonText:
                                          'NO! MAKE I ASK OGA FESS',
                                      redbuttonText: 'YES! REMOVE EQUIPMENT',
                                      title:
                                          'Are you sure you want to remove (${result[index].equipmentName}) equipment',
                                      onTapBlackButton: () =>
                                          Navigator.pop(context),
                                      onTapRedButton: () async {
                                        provider.deleteCheckinEquipment(
                                            result[index].id, context);
                                      })
                                }
                            },
                            child: SizedBox(
                              height: 100,
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
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: 'Event Name:  ',
                                          style: style.copyWith(
                                              fontSize: 11,
                                              color: AppColor.primaryColor),
                                          children: [
                                            TextSpan(
                                              text: result[index].eventName,
                                              style: style.copyWith(
                                                  fontSize: 10,
                                                  color: AppColor.darkGrey),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
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
                                                            fontSize: 13),
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
                                                              Text(
                                                                'CheckIn Date',
                                                                style: style.copyWith(
                                                                    fontSize: 8,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: AppColor
                                                                        .primaryColor),
                                                              ),
                                                              Text(
                                                                '${result[index].returnDatetime.day}th ${months[result[index].returnDatetime.month - 1]}, ${result[index].returnDatetime.year}',
                                                                style: style.copyWith(
                                                                    fontSize: 8,
                                                                    color: AppColor
                                                                        .darkGrey),
                                                              ),
                                                              const SizedBox(
                                                                  height: 2),
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
                                                                          .checkinUserName,
                                                                      style: style.copyWith(
                                                                          fontSize:
                                                                              10,
                                                                          color:
                                                                              AppColor.darkGrey),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
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
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

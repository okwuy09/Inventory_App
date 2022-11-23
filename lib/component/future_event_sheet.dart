import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/button.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/popover.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/future_event.dart';
import 'package:viicsoft_inventory_app/models/profile.dart';
import 'package:viicsoft_inventory_app/services/apis/user_api.dart';
import 'package:viicsoft_inventory_app/ui/event/future_event_equipment.dart';
import 'package:viicsoft_inventory_app/ui/event/update_event.dart';

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
// print(months[mon+1]);

void futureEventDetailbuttomSheet(
  context,
  EventsFuture eventDetail,
  String eventImage,
  String eventName,
  DateTime startDate,
  DateTime endDate,
  String eventLocation,
) {
  showModalBottomSheet<int>(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Popover(
          mainAxisSize: MainAxisSize.max,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eventName,
                style: style.copyWith(color: AppColor.black, fontSize: 26),
              ),
              const SizedBox(height: 15),
              Text(
                "Location:  $eventLocation",
                style: style.copyWith(
                  color: AppColor.darkGrey,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    "Date:  ${startDate.day}th ${months[startDate.month - 1]}",
                    style: style.copyWith(
                      color: AppColor.darkGrey,
                    ),
                  ),
                  Text(
                    " -  ${endDate.day}th ${months[endDate.month - 1]}, ${endDate.year}",
                    style: style.copyWith(
                      color: AppColor.darkGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    height: 38,
                    width: 122,
                    decoration: BoxDecoration(
                        color: DateTime.now().isAfter(endDate)
                            ? AppColor.lightGrey
                            : startDate.isBefore(DateTime.now()) &&
                                    endDate.isAfter(DateTime.now())
                                ? const Color(0xFFEDF9F3)
                                : DateTime.now().isBefore(startDate)
                                    ? const Color(0xFFFFFAEC)
                                    : null,
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(
                        DateTime.now().isAfter(endDate)
                            ? 'Ended'
                            : startDate.isBefore(DateTime.now()) &&
                                    endDate.isAfter(DateTime.now())
                                ? 'Ongoing'
                                : DateTime.now().isBefore(startDate)
                                    ? 'Not Started Yet'
                                    : '',
                        style: style.copyWith(
                          fontSize: 12,
                          color: DateTime.now().isAfter(endDate)
                              ? AppColor.darkGrey
                              : startDate.isBefore(DateTime.now()) &&
                                      endDate.isAfter(DateTime.now())
                                  ? AppColor.green
                                  : DateTime.now().isBefore(startDate)
                                      ? const Color(0xFFFFCC42)
                                      : null,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  FutureBuilder<List<Groups>>(
                      future: UserAPI().fetchUserGroup(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return const Center();
                          } else {
                            var userGroup = snapshot.data!;
                            for (var i = 0; i < userGroup.length; i++) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  userGroup[i].id == '22'
                                      ? MainButton(
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => UpdateEventPage(
                                                  eventDetail: eventDetail),
                                            ),
                                          ),
                                          child: Text(
                                            'EDIT EVENT',
                                            style: style.copyWith(
                                              fontSize: 14,
                                              color: AppColor.primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          backgroundColor: AppColor.white,
                                          borderColor: AppColor.primaryColor,
                                        )
                                      : Container(),
                                  const SizedBox(height: 10),
                                  MainButton(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                FutureEventsEquipment(
                                                  eventDetail: eventDetail,
                                                  string: userGroup[i].id,
                                                ))),
                                    child: Text(
                                      'VIEW EQUIPMENTS',
                                      style: style.copyWith(
                                        fontSize: 14,
                                        color: AppColor.buttonText,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    backgroundColor: AppColor.primaryColor,
                                    borderColor: Colors.transparent,
                                  ),
                                ],
                              );
                            }
                          }
                        }
                        return const Center();
                      })
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

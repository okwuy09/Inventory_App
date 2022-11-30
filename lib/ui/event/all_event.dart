import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/confirm_delete_sheet.dart';
import 'package:viicsoft_inventory_app/component/event_detail_sheet.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/events.dart';
import 'package:viicsoft_inventory_app/services/provider/appdata.dart';
import 'package:viicsoft_inventory_app/services/provider/userdata.dart';

class AllEvent extends StatefulWidget {
  const AllEvent({Key? key}) : super(key: key);

  @override
  State<AllEvent> createState() => _AllEventState();
}

class _AllEventState extends State<AllEvent> {
  @override
  Widget build(BuildContext context) {
    var priority = Provider.of<UserData>(context).userData.rolesPriority;
    var provider = Provider.of<AppData>(context);
    return Column(
      children: [
        Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder<List<Event>>(
                    stream: provider.fetchAllEvent(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return pageCircularIndicator;
                      } else {
                        final results = snapshot.data!;
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          itemCount: results.length,
                          itemBuilder: (_, int index) {
                            return InkWell(
                              onLongPress: () async {
                                if (priority == 'admin') {
                                  confirmDeleteSheet(
                                      context: context,
                                      blackbuttonText:
                                          'NO! MAKE I ASK OGA FESS',
                                      redbuttonText: 'YES! DELETE EVENT',
                                      title:
                                          'Are you sure you want to permanently delete (${results[index].eventName}) event',
                                      onTapBlackButton: () =>
                                          Navigator.pop(context),
                                      onTapRedButton: () async {
                                        provider.deleteEvent(
                                            results[index].id, context);
                                      });
                                }
                              },
                              child: SizedBox(
                                height: 147,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  results[index].eventName,
                                                  style: style.copyWith(
                                                      color: AppColor.black),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  'Location: ${results[index].eventLocation}',
                                                  style: style.copyWith(
                                                    fontSize: 14,
                                                    color: AppColor.darkGrey,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    eventDetailbuttomSheet(
                                                      context,
                                                      results[index],
                                                      results[index].eventImage,
                                                      results[index].eventName,
                                                      results[index]
                                                          .checkOutDate,
                                                      results[index]
                                                          .checkInDate,
                                                      results[index]
                                                          .eventLocation,
                                                    );
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    width: 280,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                        color: AppColor.black,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'VIEW EVENT DETAIL',
                                                        style: style.copyWith(
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
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
      ],
    );
  }
}

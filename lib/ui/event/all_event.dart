import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/confirm_delete_sheet.dart';
import 'package:viicsoft_inventory_app/component/event_detail_sheet.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/component/success_button_sheet.dart';
import 'package:viicsoft_inventory_app/models/events.dart';
import 'package:viicsoft_inventory_app/models/profile.dart';
import 'package:viicsoft_inventory_app/services/apis/event_api.dart';
import 'package:viicsoft_inventory_app/services/apis/user_api.dart';

class AllEvent extends StatefulWidget {
  const AllEvent({Key? key}) : super(key: key);

  @override
  State<AllEvent> createState() => _AllEventState();
}

class _AllEventState extends State<AllEvent> {
  Future refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Expanded(
                    child: FutureBuilder<List<Event>>(
                        future: EventAPI().fetchAllEvents(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: CircularProgressIndicator(
                                  color: AppColor.darkGrey),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.done) {
                            final results = snapshot.data!;
                            return ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                itemCount: results.length,
                                itemBuilder: (_, int index) {
                                  return FutureBuilder<List<Groups>>(
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
                                              onLongPress: () async {
                                                if (userGroup[i].id == '22') {
                                                  confirmDeleteSheet(
                                                      context: context,
                                                      blackbuttonText:
                                                          'NO! MAKE I ASK OGA FESS',
                                                      redbuttonText:
                                                          'YES! DELETE CATEGORY',
                                                      title:
                                                          'Are you sure you want to permanently delete (${results[index].eventName}) event',
                                                      onTapBlackButton: () =>
                                                          Navigator.pop(
                                                              context),
                                                      onTapRedButton: () async {
                                                        var res = await EventAPI()
                                                            .deleteEvent(
                                                                results[index]
                                                                    .id);
                                                        if (res.statusCode ==
                                                            200) {
                                                          successButtomSheet(
                                                            context: context,
                                                            buttonText:
                                                                'BACK TO MY PROFILE',
                                                            title:
                                                                'Event Deleted\n  Successfully',
                                                            onTap: () =>
                                                                Navigator.pop(
                                                                    context),
                                                          );
                                                        }
                                                      });
                                                }
                                              },
                                              child: SizedBox(
                                                height: 147,
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  elevation: 0,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15.0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  results[index]
                                                                      .eventName
                                                                      .toString(),
                                                                  style: style
                                                                      .copyWith(
                                                                          color:
                                                                              AppColor.black),
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                  'Location: ${results[index].eventLocation.toString()}',
                                                                  style: style
                                                                      .copyWith(
                                                                    fontSize:
                                                                        14,
                                                                    color: AppColor
                                                                        .darkGrey,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    eventDetailbuttomSheet(
                                                                      context,
                                                                      results[
                                                                          index],
                                                                      results[index]
                                                                          .eventImage,
                                                                      results[index]
                                                                          .eventName,
                                                                      results[index]
                                                                          .checkOutDate,
                                                                      results[index]
                                                                          .checkInDate,
                                                                      results[index]
                                                                          .eventLocation,
                                                                    );
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height: 40,
                                                                    width: 280,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: AppColor
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'VIEW EVENT DETAIL',
                                                                        style: style.copyWith(
                                                                            fontSize:
                                                                                12),
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
                                          }
                                        }
                                      }
                                      return Container();
                                    },
                                  );
                                });
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                  color: AppColor.darkGrey),
                            );
                          }
                        }),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

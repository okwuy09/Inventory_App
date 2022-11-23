import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/event_detail_sheet.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/pastevent.dart';
import 'package:viicsoft_inventory_app/services/apis/event_api.dart';

class PastEvent extends StatefulWidget {
  const PastEvent({Key? key}) : super(key: key);

  @override
  State<PastEvent> createState() => _PastEventState();
}

class _PastEventState extends State<PastEvent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: AppColor.homePageColor,
            ),
            child: Column(
              children: [
                Expanded(
                  child: FutureBuilder<List<EventsPast>>(
                      future: EventAPI().fetchPastEvents(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center();
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          final results = snapshot.data!;
                          return ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              itemCount: results.length,
                              itemBuilder: (_, int index) {
                                return InkWell(
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
                                                      results[index]
                                                          .eventName
                                                          .toString(),
                                                      style: style.copyWith(
                                                          color:
                                                              AppColor.black),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      'Location: ${results[index].eventLocation.toString()}',
                                                      style: style.copyWith(
                                                        fontSize: 14,
                                                        color:
                                                            AppColor.darkGrey,
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
                                                      child: Container(
                                                        height: 40,
                                                        width: 280,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          border: Border.all(
                                                            color:
                                                                AppColor.black,
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            'VIEW EVENT DETAIL',
                                                            style:
                                                                style.copyWith(
                                                              fontSize: 12,
                                                            ),
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
                              });
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColor.darkGrey,
                            ),
                          );
                        }
                      }),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

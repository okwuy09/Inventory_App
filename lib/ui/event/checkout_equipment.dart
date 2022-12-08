import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viicsoft_inventory_app/component/checkout_equipment.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/eventequipmentcheckout.dart';
import 'package:viicsoft_inventory_app/models/events.dart';
import 'package:viicsoft_inventory_app/services/provider/appdata.dart';

// ignore: must_be_immutable
class CheckOutEquipmentPage extends StatefulWidget {
  const CheckOutEquipmentPage({Key? key}) : super(key: key);

  @override
  State<CheckOutEquipmentPage> createState() => _CheckOutEquipmentPageState();
}

class _CheckOutEquipmentPageState extends State<CheckOutEquipmentPage> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppData>(context);
    return Scaffold(
      backgroundColor: AppColor.homePageColor,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        toolbarHeight: 75,
        automaticallyImplyLeading: false,
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
            Text('Checked Out Equipment',
                style: style.copyWith(fontWeight: FontWeight.bold)),
            Expanded(child: Container()),
          ],
        ),
      ),
      body: StreamBuilder<List<Event>>(
        stream: provider.fetchAllEvent(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return buttonCircularIndicator;
          } else {
            var event = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: StreamBuilder<List<EventsEquipmentCheckout>>(
                    stream: provider.fetchAllCheckOutEquipment(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return pageCircularIndicator;
                      } else {
                        var checkoutEquipments = snapshot.data!;
                        var eventId = List<String>.generate(
                            checkoutEquipments.length,
                            (i) => checkoutEquipments[i].eventId).toList();
                        var events = event
                            .where((element) => eventId.contains(element.id))
                            .toList();

                        return MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            itemCount: events.length,
                            itemBuilder: (_, int index) {
                              return SizedBox(
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
                                                  events[index].eventName,
                                                  style: style.copyWith(
                                                      color: AppColor.black),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  'Location: ${events[index].eventLocation}',
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
                                                    handleCheckoutEquipment(
                                                        context: context,
                                                        events: events[index]);
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
                                                        'VIEW CHECKED OUT EQUIPMENTS',
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
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}

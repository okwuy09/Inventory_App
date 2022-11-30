import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:viicsoft_inventory_app/component/button.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/confirm_delete_sheet.dart';
import 'package:viicsoft_inventory_app/component/popover.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/equipments.dart';
import 'package:viicsoft_inventory_app/models/events.dart';
import 'package:viicsoft_inventory_app/services/provider/appdata.dart';
import 'package:viicsoft_inventory_app/services/provider/userdata.dart';
import 'package:viicsoft_inventory_app/ui/event/add_eventequipmentpage.dart';
import 'package:viicsoft_inventory_app/ui/store/update_checkin_equipment.dart';

class FutureEventsEquipment extends StatefulWidget {
  final Event eventDetail;
  // ignore: prefer_typing_uninitialized_variables
  //final String? string;
  const FutureEventsEquipment({Key? key, required this.eventDetail})
      : super(key: key);

  @override
  State<FutureEventsEquipment> createState() => _FutureEventsEquipmentState();
}

class _FutureEventsEquipmentState extends State<FutureEventsEquipment> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List scanedEquipment = [];
  String _scanInBarcode = '';

  Future refresh() async {
    setState(() {});
  }

  Future scanInBarcode() async {
    String barcodescanIn;
    try {
      barcodescanIn = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodescanIn = 'Failed to get platform version.';
    }

    if (!mounted) return;
    setState(() {
      _scanInBarcode = barcodescanIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    var priority = Provider.of<UserData>(context).userData;
    var provider = Provider.of<AppData>(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        toolbarHeight: 65,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          const SizedBox(width: 5),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 26,
              color: AppColor.iconBlack,
            ),
          ),
          const SizedBox(width: 26.5),
          Center(
            child: Text(widget.eventDetail.eventName, style: style),
          ),
          Expanded(child: Container()),
        ],
      ),
      backgroundColor: AppColor.homePageColor,
      body: StreamBuilder<List<Event>>(
          stream: provider.fetchAllEvent(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return pageCircularIndicator;
            } else {
              var events = snapshot.data!;
              var event =
                  events.where((e) => e.id == widget.eventDetail.id).toList();
              return StreamBuilder<List<EquipmentElement>>(
                stream: provider.fetchAllEquipment(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return pageCircularIndicator;
                  } else {
                    var results = snapshot.data!;
                    var checkOutequipmentid = List<String>.generate(
                        event[0].eventEquipment.length,
                        (i) => event[0].eventEquipment[i].equipmentId).toList();
                    var result = results
                        .where((e) => checkOutequipmentid.contains(e.id))
                        .toList();
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'EQUIPMENTS TO BE USED',
                                textAlign: TextAlign.center,
                                style: style.copyWith(color: AppColor.darkGrey),
                              ),
                              Expanded(child: Container()),
                              Container(
                                padding: const EdgeInsets.all(4),
                                height: 38,
                                width: 122,
                                decoration: BoxDecoration(
                                    color: DateTime.now()
                                            .isAfter(event[0].checkInDate)
                                        ? AppColor.lightGrey
                                        : event[0]
                                                    .checkOutDate
                                                    .isBefore(DateTime.now()) &&
                                                event[0]
                                                    .checkInDate
                                                    .isAfter(DateTime.now())
                                            ? const Color(0xFFEDF9F3)
                                            : DateTime.now().isBefore(
                                                    event[0].checkOutDate)
                                                ? const Color(0xFFFFFAEC)
                                                : null,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: Text(
                                    DateTime.now().isAfter(event[0].checkInDate)
                                        ? 'Ended'
                                        : event[0]
                                                    .checkOutDate
                                                    .isBefore(DateTime.now()) &&
                                                event[0]
                                                    .checkInDate
                                                    .isAfter(DateTime.now())
                                            ? 'Ongoing'
                                            : DateTime.now().isBefore(
                                                    event[0].checkOutDate)
                                                ? 'Not Started Yet'
                                                : '',
                                    style: style.copyWith(
                                      fontSize: 12,
                                      color: DateTime.now()
                                              .isAfter(event[0].checkInDate)
                                          ? AppColor.darkGrey
                                          : event[0].checkOutDate.isBefore(
                                                      DateTime.now()) &&
                                                  event[0]
                                                      .checkInDate
                                                      .isAfter(DateTime.now())
                                              ? AppColor.green
                                              : DateTime.now().isBefore(
                                                      event[0].checkOutDate)
                                                  ? const Color(0xFFFFCC42)
                                                  : null,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screensize.height * 0.02),
                          SizedBox(
                            height: screensize.height * 0.65,
                            child: ListView.builder(
                              itemCount: result.length,
                              itemBuilder: (_, int index) {
                                return InkWell(
                                  onLongPress: () {
                                    if (priority.rolesPriority == 'admin') {
                                      confirmDeleteSheet(
                                        context: context,
                                        title:
                                            'Are you sure you want to remove (${results[index].equipmentName}) equipment',
                                        blackbuttonText:
                                            'NO! MAKE I ASK OGA FESS',
                                        redbuttonText: 'YES! REMOVE EQUIPMENT',
                                        onTapBlackButton: () =>
                                            Navigator.pop(context),
                                        onTapRedButton: () async {
                                          await provider.removeEventEquipment(
                                            equipmentId: result[index].id,
                                            ischeckedOut: false,
                                            eventId: event[0].id,
                                            context: context,
                                          );
                                        },
                                      );
                                    }
                                  },
                                  child: SizedBox(
                                    height: 90,
                                    child: Builder(
                                      builder: (context) {
                                        //var checkoutequipment = snapshot.data;

                                        return Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          elevation: 0,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width: 56,
                                                              height: 56,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                                image:
                                                                    DecorationImage(
                                                                  image: NetworkImage(
                                                                      result[index]
                                                                          .equipmentImage),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 12,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  result[index]
                                                                      .equipmentName,
                                                                  maxLines: 1,
                                                                  style: style
                                                                      .copyWith(
                                                                    color: AppColor
                                                                        .black,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 2),
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
                                                                          color: result[index].equipmentCondition == 'BAD'
                                                                              ? const Color(0xFFFEEAEA)
                                                                              : result[index].equipmentCondition == 'NEW' || result[index].equipmentCondition == 'OLD'
                                                                                  ? const Color(0xFFEDF9F3)
                                                                                  : result[index].equipmentCondition == 'FAIR'
                                                                                      ? const Color(0xFFFFFAEC)
                                                                                      : null,
                                                                          borderRadius: BorderRadius.circular(8)),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          result[index].equipmentCondition == 'BAD'
                                                                              ? 'Bad'
                                                                              : result[index].equipmentCondition == 'NEW' || result[index].equipmentCondition == 'OLD'
                                                                                  ? 'Good'
                                                                                  : result[index].equipmentCondition == 'FAIR'
                                                                                      ? 'Fair'
                                                                                      : '',
                                                                          style:
                                                                              style.copyWith(
                                                                            fontSize:
                                                                                12,
                                                                            color: result[index].equipmentCondition == 'BAD'
                                                                                ? AppColor.red
                                                                                : result[index].equipmentCondition == 'NEW' || result[index].equipmentCondition == 'OLD'
                                                                                    ? AppColor.green
                                                                                    : result[index].equipmentCondition == 'FAIR'
                                                                                        ? const Color(0xFFFFCC42)
                                                                                        : null,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: screensize
                                                                              .width *
                                                                          0.23,
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () async {},
                                                                      child: result[index]
                                                                              .isEquipmentAvialable
                                                                          ? InkWell(
                                                                              onTap: () {
                                                                                if (priority.rolesPriority == 'admin') {
                                                                                  showBottomSheet(
                                                                                    context: context,
                                                                                    builder: (_) {
                                                                                      return Popover(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        child: Column(
                                                                                          children: [
                                                                                            Text('Ready to check out this (${result[index].equipmentName}) equipment ?'),
                                                                                            const SizedBox(height: 24),
                                                                                            const Divider(),
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.only(top: 10, bottom: 24),
                                                                                              child: MainButton(
                                                                                                  child: Text(
                                                                                                    'SCAN BARCODE',
                                                                                                    style: style.copyWith(
                                                                                                      fontSize: 14,
                                                                                                      color: AppColor.buttonText,
                                                                                                      fontWeight: FontWeight.bold,
                                                                                                    ),
                                                                                                  ),
                                                                                                  backgroundColor: AppColor.primaryColor,
                                                                                                  borderColor: Colors.transparent,
                                                                                                  onTap: () async {
                                                                                                    Navigator.pop(context);
                                                                                                    await _checkOut(
                                                                                                      provider,
                                                                                                      result[index],
                                                                                                      event[0].id,
                                                                                                      priority.fullName!,
                                                                                                    );
                                                                                                  }),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                  );
                                                                                }
                                                                              },
                                                                              child: Text(
                                                                                'Not CheckedOut',
                                                                                style: style.copyWith(
                                                                                  fontSize: 10,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: AppColor.green,
                                                                                  fontStyle: FontStyle.italic,
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : InkWell(
                                                                              onTap: () {
                                                                                if (priority.rolesPriority == 'admin') {
                                                                                  Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                      builder: (_) => UpdateCheckInEquipment(equipment: result[index], event: event[0], index: index),
                                                                                    ),
                                                                                  );
                                                                                }
                                                                              },
                                                                              child: Text(
                                                                                'Checked Out',
                                                                                style: style.copyWith(
                                                                                  fontSize: 10,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: AppColor.red,
                                                                                  fontStyle: FontStyle.italic,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 15),
                          MainButton(
                            borderColor: Colors.transparent,
                            child: Text(
                              priority.rolesPriority == 'admin'
                                  ? 'ADD EQUIPMENTS'
                                  : 'BACK',
                              style: style.copyWith(
                                fontSize: 14,
                                color: AppColor.buttonText,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: AppColor.primaryColor,
                            onTap: () => priority.rolesPriority == 'admin'
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AddEventEquipmentPage(
                                        event: event[0],
                                      ),
                                    ),
                                  )
                                : Navigator.pop(context),
                          ),
                        ],
                      ),
                    );
                  }
                },
              );
            }
          }),
    );
  }

  _checkOut(AppData provider, EquipmentElement equipment, String eventId,
      String userName) async {
    await scanInBarcode();
    if (equipment.equipmentBarcode == _scanInBarcode) {
      return provider
          .addEventsEquipmentCheckout(
            context: context,
            eventId: eventId,
            equipmentId: equipment.id,
            equipmentOutDatetime: DateTime.now(),
            checkOutUserName: userName,
            equipmentCondition: equipment.equipmentCondition,
            equipmentImage: equipment.equipmentImage,
            equipmentName: equipment.equipmentName,
            eventName: widget.eventDetail.eventName,
            isReturned: false,
          )
          .then(
            (value) async => await provider.checkedOut(equipment.id),
          );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:viicsoft_inventory_app/component/button.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/confirm_delete_sheet.dart';
import 'package:viicsoft_inventory_app/component/mytextform.dart';
import 'package:viicsoft_inventory_app/component/popover.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/equipment_not_avialable.dart';
import 'package:viicsoft_inventory_app/models/eventequipmentchecklist.dart';
import 'package:viicsoft_inventory_app/models/future_event.dart';
import 'package:viicsoft_inventory_app/services/apis/equipment_api.dart';
import 'package:viicsoft_inventory_app/services/apis/equipment_checkin_api.dart';
import 'package:viicsoft_inventory_app/services/apis/equipment_checklist_api.dart';
import 'package:viicsoft_inventory_app/services/apis/equipment_checkout_api.dart';
import 'package:viicsoft_inventory_app/ui/event/add_eventequipmentpage.dart';
import 'package:viicsoft_inventory_app/ui/store/update_checkin_equipment.dart';

class FutureEventsEquipment extends StatefulWidget {
  final EventsFuture eventDetail;
  // ignore: prefer_typing_uninitialized_variables
  final String? string;
  const FutureEventsEquipment(
      {Key? key, required this.eventDetail, this.string})
      : super(key: key);

  @override
  State<FutureEventsEquipment> createState() => _FutureEventsEquipmentState();
}

class _FutureEventsEquipmentState extends State<FutureEventsEquipment> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final EquipmentCheckInAPI _equipmentCheckInAPI = EquipmentCheckInAPI();

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
      body: RefreshIndicator(
        onRefresh: refresh,
        child: FutureBuilder<List<EventEquipmentChecklist>>(
          future: EventEquipmentChecklistAPI().fetchAllEquipmentCheckList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == null) {
                return const Center();
              } else {
                var results = snapshot.data!;
                var result = results
                    .where((e) => widget.eventDetail.id.contains(e.eventId))
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
                                        .isAfter(widget.eventDetail.checkInDate)
                                    ? AppColor.lightGrey
                                    : widget.eventDetail.checkOutDate
                                                .isBefore(DateTime.now()) &&
                                            widget.eventDetail.checkInDate
                                                .isAfter(DateTime.now())
                                        ? const Color(0xFFEDF9F3)
                                        : DateTime.now().isBefore(
                                                widget.eventDetail.checkOutDate)
                                            ? const Color(0xFFFFFAEC)
                                            : null,
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                              child: Text(
                                DateTime.now()
                                        .isAfter(widget.eventDetail.checkInDate)
                                    ? 'Ended'
                                    : widget.eventDetail.checkOutDate
                                                .isBefore(DateTime.now()) &&
                                            widget.eventDetail.checkInDate
                                                .isAfter(DateTime.now())
                                        ? 'Ongoing'
                                        : DateTime.now().isBefore(
                                                widget.eventDetail.checkOutDate)
                                            ? 'Not Started Yet'
                                            : '',
                                style: style.copyWith(
                                  fontSize: 12,
                                  color: DateTime.now().isAfter(
                                          widget.eventDetail.checkInDate)
                                      ? AppColor.darkGrey
                                      : widget.eventDetail.checkOutDate
                                                  .isBefore(DateTime.now()) &&
                                              widget.eventDetail.checkInDate
                                                  .isAfter(DateTime.now())
                                          ? AppColor.green
                                          : DateTime.now().isBefore(widget
                                                  .eventDetail.checkOutDate)
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
                                if (widget.string == '22') {
                                  confirmDeleteSheet(
                                    context: context,
                                    title:
                                        'Are you sure you want to remove (${results[index].equipment.equipmentName}) equipment',
                                    blackbuttonText: 'NO! MAKE I ASK OGA FESS',
                                    redbuttonText: 'YES! REMOVE EQUIPMENT',
                                    onTapBlackButton: () =>
                                        Navigator.pop(context),
                                    onTapRedButton: () async {
                                      var res =
                                          await EventEquipmentChecklistAPI()
                                              .deleteEventEquipmentsChecklist(
                                                  result[index].id);
                                      if (res.statusCode == 200) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                backgroundColor: Colors.green,
                                                content: Text(
                                                    "Equipment successfully removed")));
                                        Navigator.pop(context);
                                        setState(() {});
                                      }
                                    },
                                  );
                                }
                              },
                              child: SizedBox(
                                height: 90,
                                child: FutureBuilder<
                                    List<EquipmentsNotAvailableElement>>(
                                  future: EquipmentAPI()
                                      .fetchEquipmentsNotAvialable(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      var checkoutequipment = snapshot.data;
                                      var checkOutequipmentid =
                                          List<String>.generate(
                                              checkoutequipment!.length,
                                              (i) => checkoutequipment[i]
                                                  .equipmentId);
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
                                                  width: MediaQuery.of(context)
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
                                                                        .equipment
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
                                                                    .equipment
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
                                                                        const EdgeInsets
                                                                            .all(4),
                                                                    height: 30,
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
                                                                        result[index].equipment.equipmentCondition ==
                                                                                'BAD'
                                                                            ? 'Bad'
                                                                            : result[index].equipment.equipmentCondition == 'NEW' || result[index].equipment.equipmentCondition == 'OLD'
                                                                                ? 'Good'
                                                                                : result[index].equipment.equipmentCondition == 'FAIR'
                                                                                    ? 'Fair'
                                                                                    : '',
                                                                        style: style
                                                                            .copyWith(
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
                                                                  SizedBox(
                                                                    width: screensize
                                                                            .width *
                                                                        0.26,
                                                                  ),
                                                                  InkWell(
                                                                    onTap:
                                                                        () async {},
                                                                    child: !checkOutequipmentid
                                                                            .contains(result[index].equipmentId)
                                                                        ? InkWell(
                                                                            onTap:
                                                                                () {
                                                                              if (widget.string == '22') {
                                                                                showBottomSheet(
                                                                                  context: context,
                                                                                  builder: (_) {
                                                                                    return Popover(
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      child: Column(
                                                                                        children: [
                                                                                          Text('Ready to check out this (${result[index].equipment.equipmentName}) equipment ?'),
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
                                                                                                  await _checkOut(result[index].equipment.equipmentBarcode, result[index].equipmentId, result[index].eventId);
                                                                                                  setState(() {});
                                                                                                }),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                );
                                                                              }
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              'Not CheckedOut',
                                                                              style: style.copyWith(
                                                                                fontSize: 9,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: AppColor.green,
                                                                                fontStyle: FontStyle.italic,
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : InkWell(
                                                                            onTap:
                                                                                () {
                                                                              if (widget.string == '22') {
                                                                                Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                    builder: (_) => UpdateCheckInEquipment(equipment: result[index]),
                                                                                  ),
                                                                                );
                                                                              }
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              'Checked Out',
                                                                              style: style.copyWith(
                                                                                fontSize: 9,
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
                                    }
                                    return const Center();
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
                          widget.string == '22' ? 'ADD EQUIPMENTS' : 'BACK',
                          style: style.copyWith(
                            fontSize: 14,
                            color: AppColor.buttonText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: AppColor.primaryColor,
                        onTap: () => widget.string == '22'
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddEventEquipmentPage(
                                      eventId: widget.eventDetail.id,
                                      eventName: widget.eventDetail.eventName),
                                ),
                              )
                            : Navigator.pop(context),
                      ),
                    ],
                  ),
                );
              }
            }
            return Center(
              child: CircularProgressIndicator(
                color: AppColor.darkGrey,
              ),
            );
          },
        ),
      ),
    );
  }

  _checkIn(String? equipmentBarcode, String equipmentId) async {
    await scanInBarcode();
    if (equipmentBarcode == _scanInBarcode) {
      return await _equipmentCheckInAPI.checkinEquipments(equipmentId);
    }
  }

  _checkOut(
      String? equipmentBarcode, String equipmentId, String eventId) async {
    await scanInBarcode();
    if (equipmentBarcode == _scanInBarcode) {
      var res =
          await EquipmentCheckOutAPI().checkoutEquipments(eventId, equipmentId);
      return res;
    }
  }
}

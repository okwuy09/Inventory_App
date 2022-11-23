import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:viicsoft_inventory_app/component/button.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/popover.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/equipment_not_avialable.dart';
import 'package:viicsoft_inventory_app/models/eventequipmentchecklist.dart';
import 'package:viicsoft_inventory_app/models/profile.dart';
import 'package:viicsoft_inventory_app/services/apis/equipment_api.dart';
import 'package:viicsoft_inventory_app/services/apis/equipment_checkin_api.dart';
import 'package:viicsoft_inventory_app/services/apis/equipment_checklist_api.dart';
import 'package:viicsoft_inventory_app/services/apis/user_api.dart';
import 'package:viicsoft_inventory_app/ui/store/update_checkin_equipment.dart';

class EventsEquipment extends StatefulWidget {
  final dynamic eventDetail;
  const EventsEquipment({Key? key, required this.eventDetail})
      : super(key: key);

  @override
  State<EventsEquipment> createState() => _EventsEquipmentState();
}

class _EventsEquipmentState extends State<EventsEquipment> {
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
                            'EQUIPMENTS USED',
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
                      Expanded(
                          child: ListView.builder(
                        itemCount: result.length,
                        itemBuilder: (_, int index) {
                          return SizedBox(
                            height: 88,
                            child: FutureBuilder<
                                List<EquipmentsNotAvailableElement>>(
                              future:
                                  EquipmentAPI().fetchEquipmentsNotAvialable(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  var checkoutequipment = snapshot.data;
                                  var checkOutequipmentid =
                                      List<String>.generate(
                                          checkoutequipment!.length,
                                          (i) =>
                                              checkoutequipment[i].equipmentId);
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
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
                                                    CrossAxisAlignment.start,
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
                                                                  .circular(4),
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                result[index]
                                                                    .equipment
                                                                    .equipmentImage),
                                                            fit: BoxFit.cover,
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
                                                            style:
                                                                style.copyWith(
                                                              color: AppColor
                                                                  .black,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 2),
                                                          FutureBuilder<
                                                              List<Groups>>(
                                                            future: UserAPI()
                                                                .fetchUserGroup(),
                                                            builder: (context,
                                                                snapshot) {
                                                              if (snapshot
                                                                      .connectionState ==
                                                                  ConnectionState
                                                                      .done) {
                                                                if (snapshot
                                                                    .hasError) {
                                                                  return const Center();
                                                                } else {
                                                                  var userGroup =
                                                                      snapshot
                                                                          .data!;
                                                                  for (var i =
                                                                          0;
                                                                      i <
                                                                          userGroup
                                                                              .length;
                                                                      i++) {
                                                                    return Row(
                                                                      children: [
                                                                        Container(
                                                                          padding:
                                                                              const EdgeInsets.all(4),
                                                                          height:
                                                                              30,
                                                                          width:
                                                                              52,
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
                                                                              style: style.copyWith(
                                                                                fontSize: 12,
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
                                                                            width:
                                                                                screensize.width * 0.29),
                                                                        InkWell(
                                                                          onTap:
                                                                              () async {},
                                                                          child: checkOutequipmentid.contains(result[index].equipmentId)
                                                                              ? InkWell(
                                                                                  onTap: () {
                                                                                    if (userGroup[i].id == '22') {
                                                                                      Navigator.push(
                                                                                        context,
                                                                                        MaterialPageRoute(
                                                                                          builder: (_) => UpdateCheckInEquipment(equipment: result[index]),
                                                                                        ),
                                                                                      );
                                                                                    }
                                                                                  },
                                                                                  child: Text(
                                                                                    'Not Checked In',
                                                                                    style: TextStyle(
                                                                                      fontWeight: FontWeight.bold,
                                                                                      fontSize: 8,
                                                                                      color: AppColor.red,
                                                                                      fontStyle: FontStyle.italic,
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              : InkWell(
                                                                                  onTap: () {
                                                                                    if (userGroup[i].id == '22') {
                                                                                      showBottomSheet(
                                                                                        context: context,
                                                                                        builder: (_) {
                                                                                          return Popover(
                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                            child: Column(
                                                                                              children: [
                                                                                                Text('${result[index].equipment.equipmentName} Checked In and Barcode Scanned'),
                                                                                                const SizedBox(height: 18),
                                                                                                const Divider(),
                                                                                                Padding(
                                                                                                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                                                                                                  child: Row(
                                                                                                    children: [
                                                                                                      Text(
                                                                                                        'By Alber Obiefuna',
                                                                                                        style: style.copyWith(fontSize: 12, color: AppColor.darkGrey),
                                                                                                      ),
                                                                                                      Expanded(child: Container()),
                                                                                                      Text(
                                                                                                        '${result[index].event.checkInDate.day} - ${result[index].event.checkInDate.month}-${result[index].event.checkInDate.year}',
                                                                                                        style: style.copyWith(fontSize: 12, color: AppColor.darkGrey),
                                                                                                      )
                                                                                                    ],
                                                                                                  ),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                      );
                                                                                    }
                                                                                  },
                                                                                  child: Text(
                                                                                    'Checked In',
                                                                                    style: style.copyWith(
                                                                                      fontSize: 10,
                                                                                      color: AppColor.green,
                                                                                      fontStyle: FontStyle.italic,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  }
                                                                }
                                                              }
                                                              return Container();
                                                            },
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
                          );
                        },
                      )),
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
}

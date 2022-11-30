import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/popover.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/equipments.dart';
import 'package:viicsoft_inventory_app/models/events.dart';
import 'package:viicsoft_inventory_app/services/provider/appdata.dart';
import 'package:viicsoft_inventory_app/services/provider/userdata.dart';
import 'package:viicsoft_inventory_app/ui/store/update_checkin_equipment.dart';

class EventsEquipment extends StatefulWidget {
  final Event eventDetail;
  const EventsEquipment({Key? key, required this.eventDetail})
      : super(key: key);

  @override
  State<EventsEquipment> createState() => _EventsEquipmentState();
}

class _EventsEquipmentState extends State<EventsEquipment> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    var priority = Provider.of<UserData>(context).userData.rolesPriority;
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
      body: StreamBuilder<List<EquipmentElement>>(
        stream: provider.fetchAllEquipment(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center();
          } else {
            var checkOutequipmentid = List<String>.generate(
                    widget.eventDetail.eventEquipment.length,
                    (i) => widget.eventDetail.eventEquipment[i].equipmentId)
                .toList();
            var results = snapshot.data!;
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
                              color: DateTime.now()
                                      .isAfter(widget.eventDetail.checkInDate)
                                  ? AppColor.darkGrey
                                  : widget.eventDetail.checkOutDate
                                              .isBefore(DateTime.now()) &&
                                          widget.eventDetail.checkInDate
                                              .isAfter(DateTime.now())
                                      ? AppColor.green
                                      : DateTime.now().isBefore(
                                              widget.eventDetail.checkOutDate)
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
                          child: Card(
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
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
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
                                              const SizedBox(
                                                width: 12,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    result[index].equipmentName,
                                                    maxLines: 1,
                                                    style: style.copyWith(
                                                      color: AppColor.black,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4),
                                                        height: 30,
                                                        width: 52,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: result[index]
                                                                            .equipmentCondition ==
                                                                        'BAD'
                                                                    ? const Color(
                                                                        0xFFFEEAEA)
                                                                    : result[index].equipmentCondition ==
                                                                                'NEW' ||
                                                                            result[index].equipmentCondition ==
                                                                                'OLD'
                                                                        ? const Color(
                                                                            0xFFEDF9F3)
                                                                        : result[index].equipmentCondition ==
                                                                                'FAIR'
                                                                            ? const Color(
                                                                                0xFFFFFAEC)
                                                                            : null,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
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
                                                            style:
                                                                style.copyWith(
                                                              fontSize: 12,
                                                              color: result[index]
                                                                          .equipmentCondition ==
                                                                      'BAD'
                                                                  ? AppColor.red
                                                                  : result[index].equipmentCondition ==
                                                                              'NEW' ||
                                                                          result[index].equipmentCondition ==
                                                                              'OLD'
                                                                      ? AppColor
                                                                          .green
                                                                      : result[index].equipmentCondition ==
                                                                              'FAIR'
                                                                          ? const Color(
                                                                              0xFFFFCC42)
                                                                          : null,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          width:
                                                              screensize.width *
                                                                  0.22),
                                                      InkWell(
                                                        onTap: () async {},
                                                        child: !result[index]
                                                                .isEquipmentAvialable
                                                            ? InkWell(
                                                                onTap: () {
                                                                  if (priority ==
                                                                      'admin') {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (_) =>
                                                                                UpdateCheckInEquipment(
                                                                          equipment:
                                                                              result[index],
                                                                          event:
                                                                              widget.eventDetail,
                                                                          index:
                                                                              index,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                                child: Text(
                                                                  'Not Checked In',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        10,
                                                                    color:
                                                                        AppColor
                                                                            .red,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                  ),
                                                                ),
                                                              )
                                                            : InkWell(
                                                                onTap: () {
                                                                  if (priority ==
                                                                      'admin') {
                                                                    showBottomSheet(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (_) {
                                                                        return Popover(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Text('${result[index].equipmentName} Checked In and Barcode Scanned'),
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
                                                                                      '',
                                                                                      //'${result[index].event.checkInDate.day} - ${result[index].event.checkInDate.month}-${result[index].event.checkInDate.year}',
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
                                                                  style: style
                                                                      .copyWith(
                                                                    fontSize:
                                                                        10,
                                                                    color: AppColor
                                                                        .green,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
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
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

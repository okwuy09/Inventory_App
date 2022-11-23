import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/confirm_delete_sheet.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/equipmentcheckin.dart';
import 'package:viicsoft_inventory_app/models/profile.dart';
import 'package:viicsoft_inventory_app/services/apis/equipment_checkin_api.dart';
import 'package:viicsoft_inventory_app/services/apis/user_api.dart';

// ignore: must_be_immutable
class CheckInEquipmentPage extends StatefulWidget {
  const CheckInEquipmentPage({Key? key}) : super(key: key);

  @override
  State<CheckInEquipmentPage> createState() => _CheckInEquipmentPageState();
}

class _CheckInEquipmentPageState extends State<CheckInEquipmentPage> {
  Future refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
      body: RefreshIndicator(
        onRefresh: refresh,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<EquipmentsCheckin>>(
                future: EquipmentCheckInAPI().fetchAllEquipmentCheckIn(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColor.red,
                        ),
                      );
                    } else {
                      var result = snapshot.data!;
                      return MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: ListView.builder(
                          itemCount: result.length,
                          itemBuilder: (_, int index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(right: 20, left: 20),
                              child: FutureBuilder<List<Groups>>(
                                future: UserAPI().fetchUserGroup(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasError) {
                                      return Center(
                                          child: CircularProgressIndicator(
                                        color: AppColor.red,
                                      ));
                                    } else {
                                      var userGroup = snapshot.data!;
                                      for (var i = 0;
                                          i < userGroup.length;
                                          i++) {
                                        return InkWell(
                                          onLongPress: () async => {
                                            if (userGroup[i].id == '22')
                                              {
                                                confirmDeleteSheet(
                                                    context: context,
                                                    blackbuttonText:
                                                        'NO! MAKE I ASK OGA FESS',
                                                    redbuttonText:
                                                        'YES! REMOVE EQUIPMENT',
                                                    title:
                                                        'Are you sure you want to remove (${result[index].equipment.equipmentName}) equipment',
                                                    onTapBlackButton: () =>
                                                        Navigator.pop(context),
                                                    onTapRedButton: () async {
                                                      var res =
                                                          await EquipmentCheckInAPI()
                                                              .deleteEventEquipmentCheckIn(
                                                                  result[index]
                                                                      .id);
                                                      if (res.statusCode ==
                                                          200) {
                                                        setState(() {});
                                                        Navigator.pop(context);
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            backgroundColor:
                                                                Colors.green,
                                                            content: Text(
                                                              "(${result[index].equipment.equipmentName})  Equipment successfully removed",
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    })
                                              }
                                          },
                                          child: SizedBox(
                                            height: 80,
                                            child: Card(
                                              color: AppColor.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
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
                                                                    .circular(
                                                                        4),
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
                                                            width: 8),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      result[index]
                                                                          .equipment
                                                                          .equipmentName,
                                                                      maxLines:
                                                                          1,
                                                                      style: style.copyWith(
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            5),
                                                                    Row(
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
                                                                        Expanded(
                                                                            child:
                                                                                Container()),
                                                                        Column(
                                                                          children: [
                                                                            Text('CheckIn Date',
                                                                                style: style.copyWith(fontSize: 8, color: AppColor.darkGrey)),
                                                                            const SizedBox(height: 5),
                                                                            Text('${result[index].equipmentInDatetime.day}-${result[index].equipmentInDatetime.month}-${result[index].equipmentInDatetime.year}',
                                                                                style: style.copyWith(fontSize: 8, color: AppColor.darkGrey))
                                                                          ],
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
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
                                        );
                                      }
                                    }
                                  }
                                  return Container();
                                },
                              ),
                            );
                          },
                        ),
                      );
                    }
                  }
                  return Center(
                    child: CircularProgressIndicator(color: AppColor.darkGrey),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

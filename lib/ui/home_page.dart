import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viicsoft_inventory_app/component/home_activities_container.dart';
import 'package:viicsoft_inventory_app/component/homebigcontainer.dart';
import 'package:viicsoft_inventory_app/component/homesmallcontainer.dart';
import 'package:viicsoft_inventory_app/models/avialable_equipment.dart';
import 'package:viicsoft_inventory_app/models/equipment_not_avialable.dart';
import 'package:viicsoft_inventory_app/models/equipmentcheckin.dart';
import 'package:viicsoft_inventory_app/models/equipments.dart';
import 'package:viicsoft_inventory_app/models/eventequipmentcheckout.dart';
import 'package:viicsoft_inventory_app/services/apis/equipment_api.dart';
import 'package:viicsoft_inventory_app/services/apis/equipment_checkin_api.dart';
import 'package:viicsoft_inventory_app/services/apis/equipment_checkout_api.dart';
import 'package:viicsoft_inventory_app/services/notification_service.dart';
import 'package:viicsoft_inventory_app/services/provider/authentication.dart';
import 'package:viicsoft_inventory_app/services/provider/userdata.dart';
import 'package:viicsoft_inventory_app/ui/Menu/user_profile/profile_page.dart';
import 'package:viicsoft_inventory_app/ui/event/checkin_equipment.dart';
import 'package:viicsoft_inventory_app/ui/event/checkout_equipment.dart';
import 'package:viicsoft_inventory_app/ui/store/avialable_equipment.dart';
import 'package:viicsoft_inventory_app/ui/store/bad_equipment.dart';
import 'package:viicsoft_inventory_app/ui/store/equipment_not_avialable.dart';
import 'package:viicsoft_inventory_app/ui/store/fair_equipment.dart';
import 'package:viicsoft_inventory_app/ui/store/good_equipment.dart';
import 'package:viicsoft_inventory_app/ui/store/totalequipment.dart';
import '../component/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final EquipmentAPI _equipmentApi = EquipmentAPI();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future refresh() async {
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<UserData>(context, listen: false)
          .fetchUserProfile(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var screensize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const ProfilePage(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: AppColor.white,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
            child: Row(
              children: [
                Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 24,
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Expanded(child: Container()),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: AppColor.buttonText),
                  ),
                  child: InkWell(
                    onTap: () => _scaffoldKey.currentState!.openDrawer(),
                    child: Icon(
                      Icons.apps_rounded,
                      size: 30,
                      color: AppColor.iconBlack,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        backgroundColor: AppColor.homePageColor,
        body: FutureBuilder<List<EquipmentElement>>(
          future: EquipmentAPI().fetchAllEquipments(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: CircularProgressIndicator(color: AppColor.darkGrey),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              final result = snapshot.data!;
              var fairResult = result
                  .where((item) => item.equipmentCondition == 'FAIR')
                  .toList();
              var badResult = result
                  .where((item) => item.equipmentCondition == 'BAD')
                  .toList();
              var newResult = result
                  .where((item) => item.equipmentCondition == 'NEW')
                  .toList();
              var oldResult = result
                  .where((item) => item.equipmentCondition == 'OLD')
                  .toList();
              var goodResult = newResult + oldResult;
              return RefreshIndicator(
                onRefresh: refresh,
                child: ListView(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.only(top: 0, left: 20, right: 20),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 22.0,
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const TotalEquipmentPage())),
                                child: HomeBigContainer(
                                  backgroundColor: AppColor.homePageTotalEquip,
                                  dividerColor: const Color(0xFF6ECAFA),
                                  title: 'Total Equipments',
                                  totalCount: result.length.toString(),
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const TotalEquipmentPage())),
                                ),
                              ),
                              Expanded(child: Container()),
                              FutureBuilder<List<EquipmentsAvailable>>(
                                  future:
                                      _equipmentApi.fetchAvialableEquipments(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasData) {
                                        var aviableEquipment = snapshot.data!;
                                        return InkWell(
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const AvialableEquipmentPage(),
                                            ),
                                          ),
                                          child: HomeBigContainer(
                                            backgroundColor: AppColor.green,
                                            dividerColor:
                                                const Color(0xFF78D0A5),
                                            title: 'Avialable Equipments',
                                            totalCount: aviableEquipment.length
                                                .toString(),
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const AvialableEquipmentPage(),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                    return const Center();
                                  }),
                              Expanded(child: Container()),
                              FutureBuilder<
                                  List<EquipmentsNotAvailableElement>>(
                                future:
                                    _equipmentApi.fetchEquipmentsNotAvialable(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return InkWell(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const EquipmentNotAvialablePage(),
                                        ),
                                      ),
                                      child: HomeBigContainer(
                                        backgroundColor: AppColor.red,
                                        dividerColor: const Color(0XFFF5605F),
                                        title: 'Unavialable Equipments',
                                        totalCount:
                                            snapshot.data!.length.toString(),
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const EquipmentNotAvialablePage(),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return const Center();
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const GoodEquipmentPage(),
                                  ),
                                ),
                                child: HomeSmallContainer(
                                  borderColor: AppColor.green,
                                  buttonColor: AppColor.green,
                                  backgroundColor: const Color(0xFFEDF9F3),
                                  title: 'Good Equipments',
                                  totalCount: goodResult.isEmpty
                                      ? '0'
                                      : '${goodResult.length}',
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const GoodEquipmentPage(),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(child: Container()),
                              InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const FairEquipmentPage(),
                                  ),
                                ),
                                child: HomeSmallContainer(
                                  borderColor: const Color(0xFFFFCC42),
                                  buttonColor: const Color(0xFFFFCC42),
                                  backgroundColor: const Color(0xFFFFFAEC),
                                  title: 'Fair Equipments',
                                  totalCount: fairResult.isEmpty
                                      ? '0'
                                      : '${fairResult.length}',
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const FairEquipmentPage(),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(child: Container()),
                              InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const BadEquipmentPage(),
                                  ),
                                ),
                                child: HomeSmallContainer(
                                  borderColor: const Color(0xFFF22B29),
                                  buttonColor: const Color(0xFFF22B29),
                                  backgroundColor: const Color(0xFFFEEAEA),
                                  title: 'Bad Equipments',
                                  totalCount: badResult.isEmpty
                                      ? '0'
                                      : '${badResult.length}',
                                  onTap: () async => {
                                    if (badResult.length > 1)
                                      {
                                        await NotificationService()
                                            .notification(),
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const BadEquipmentPage(),
                                          ),
                                        ),
                                      }
                                    else
                                      {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const BadEquipmentPage(),
                                          ),
                                        ),
                                      }
                                  },
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.width / 13),
                          Row(
                            children: [
                              Text(
                                'Quick Actions',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.width / 13),
                          SizedBox(
                            child: Column(
                              children: [
                                FutureBuilder<List<EquipmentsCheckin>>(
                                  future: EquipmentCheckInAPI()
                                      .fetchAllEquipmentCheckIn(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return InkWell(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const CheckInEquipmentPage(),
                                          ),
                                        ),
                                        child: const HomeActivitiesContainer(
                                          title: 'Check In Equipments',
                                          description:
                                              'Click to see equipments returned in past events',
                                        ),
                                      );
                                    }
                                    return const Center();
                                  },
                                ),
                                const SizedBox(height: 10.0),
                                FutureBuilder<List<EventsEquipmentCheckout>>(
                                  future: EquipmentCheckOutAPI()
                                      .fetchAllEquipmentCheckOut(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return InkWell(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CheckOutEquipmentPage(
                                              equipmentCheckout: snapshot.data,
                                            ),
                                          ),
                                        ),
                                        child: const HomeActivitiesContainer(
                                          title: 'Check Out Equipments',
                                          description:
                                              'Click to see equipment yet to be returned from events',
                                        ),
                                      );
                                    }
                                    return const Center();
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(color: AppColor.darkGrey),
              );
            }
          },
        ),
      ),
    );
  }
}

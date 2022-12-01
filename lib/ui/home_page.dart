import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viicsoft_inventory_app/component/home_activities_container.dart';
import 'package:viicsoft_inventory_app/component/homebigcontainer.dart';
import 'package:viicsoft_inventory_app/component/homesmallcontainer.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/equipments.dart';
import 'package:viicsoft_inventory_app/services/provider/appdata.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<UserData>(context, listen: false).fetchUserProfile();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppData>(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const ProfilePage(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: AppColor.white,
          toolbarHeight: 65,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 45, left: 20, right: 20),
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
        body: StreamBuilder<List<EquipmentElement>>(
          stream: provider.fetchAllEquipment(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return pageCircularIndicator;
            } else {
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
              var avialableEquipment = result
                  .where((item) => item.isEquipmentAvialable == true)
                  .toList();
              var notAvialableEquipment = result
                  .where((item) => item.isEquipmentAvialable == false)
                  .toList();
              return ListView(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(top: 15, left: 20, right: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      TotalEquipmentPage(equipment: result),
                                ),
                              ),
                              child: HomeBigContainer(
                                backgroundColor: AppColor.homePageTotalEquip,
                                dividerColor: const Color(0xFF6ECAFA),
                                title: 'Total Equipments',
                                totalCount: result.length.toString(),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        TotalEquipmentPage(equipment: result),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                            InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AvialableEquipmentPage(
                                    equipment: avialableEquipment,
                                  ),
                                ),
                              ),
                              child: HomeBigContainer(
                                backgroundColor: AppColor.green,
                                dividerColor: const Color(0xFF78D0A5),
                                title: 'Avialable Equipments',
                                totalCount:
                                    avialableEquipment.length.toString(),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AvialableEquipmentPage(
                                      equipment: avialableEquipment,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                            InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EquipmentNotAvialablePage(
                                    equipment: notAvialableEquipment,
                                  ),
                                ),
                              ),
                              child: HomeBigContainer(
                                backgroundColor: AppColor.red,
                                dividerColor: const Color(0XFFF5605F),
                                title: 'Unavialable Equipments',
                                totalCount:
                                    notAvialableEquipment.length.toString(),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EquipmentNotAvialablePage(
                                      equipment: notAvialableEquipment,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      GoodEquipmentPage(equipment: goodResult),
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
                                    builder: (_) => GoodEquipmentPage(
                                      equipment: goodResult,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                            InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      FairEquipmentPage(equipment: fairResult),
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
                                    builder: (_) => FairEquipmentPage(
                                      equipment: fairResult,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                            InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      BadEquipmentPage(equipment: badResult),
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
                                      // await NotificationService()
                                      //     .notification(),
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BadEquipmentPage(
                                            equipment: badResult,
                                          ),
                                        ),
                                      ),
                                    }
                                  else
                                    {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BadEquipmentPage(
                                            equipment: badResult,
                                          ),
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
                              // check in Equipment
                              InkWell(
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
                              ),
                              const SizedBox(height: 10.0),
                              // check out Equipment
                              InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CheckOutEquipmentPage(),
                                  ),
                                ),
                                child: const HomeActivitiesContainer(
                                  title: 'Check Out Equipments',
                                  description:
                                      'Click to see equipment yet to be returned from events',
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

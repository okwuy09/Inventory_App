import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/confirm_delete_sheet.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/users.dart';
import 'package:viicsoft_inventory_app/services/provider/userdata.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

List<String> status = [
  'user',
  'admin',
];

class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    var provider = Provider.of<UserData>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 50),
        child: StreamBuilder<List<Users>>(
          stream: provider.fetchAllUser(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return pageCircularIndicator;
            } else {
              var users = snapshot.data!;
              var normalUser =
                  users.where((item) => item.rolesPriority == 'user').toList();
              var admin =
                  users.where((item) => item.rolesPriority == 'admin').toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColor.black,
                        ),
                      ),
                      SizedBox(width: screensize.width / 5),
                      Text(
                        'Admin Panel',
                        style: style.copyWith(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screensize.height * 0.05),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 70,
                          width: screensize.width / 2.5,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColor.homePageTotalEquip,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text(
                                users.length.toString(),
                                style: style.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.white,
                                ),
                              ),
                              Text(
                                'Total Users',
                                style: style.copyWith(
                                  fontSize: 14,
                                  color: AppColor.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 70,
                          width: screensize.width / 2.5,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColor.homePageAvialableEquip,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text(
                                normalUser.length.toString(),
                                style: style.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.white,
                                ),
                              ),
                              Text(
                                'Users',
                                style: style.copyWith(
                                  fontSize: 14,
                                  color: AppColor.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 70,
                          width: screensize.width / 2.5,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColor.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text(
                                admin.length.toString(),
                                style: style.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.white,
                                ),
                              ),
                              Text(
                                'Admin',
                                style: style.copyWith(
                                  fontSize: 14,
                                  color: AppColor.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screensize.height / 30),
                  Text(
                    'User Details',
                    style: style.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screensize.height / 60),
                  Expanded(
                    child: MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: ((context, index) {
                          return Container(
                            height: 65,
                            padding: EdgeInsets.symmetric(
                                horizontal: screensize.width / 50),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.5,
                                color: AppColor.primaryColor.withOpacity(0.6),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    users[index].fullName!,
                                    style: style.copyWith(
                                      fontSize: 13,
                                      color: AppColor.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  height: 65,
                                  width: 0.5,
                                  color: AppColor.primaryColor,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 2,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      dropdownColor: AppColor.primaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                      value: users[index].rolesPriority,
                                      onChanged: (newValue) async {
                                        await provider.updateUserRole(
                                            context: context,
                                            role: newValue!,
                                            userId: users[index].id!);
                                      },
                                      items: status.map((f) {
                                        return DropdownMenuItem<String>(
                                          value: f,
                                          child: Container(
                                            padding: const EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              color: f == 'user'
                                                  ? AppColor
                                                      .homePageAvialableEquip
                                                  : AppColor.green,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              f,
                                              style: style.copyWith(
                                                fontSize: 13,
                                                color: AppColor.white,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  height: 65,
                                  width: 0.5,
                                  color: AppColor.primaryColor,
                                ),
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    confirmDeleteSheet(
                                        context: context,
                                        blackbuttonText: 'NO! CANCEL',
                                        redbuttonText: 'YES! DELETE',
                                        title:
                                            'Are you sure you want to permanently delete ( ${users[index].fullName})',
                                        onTapBlackButton: () =>
                                            Navigator.pop(context),
                                        onTapRedButton: () async {
                                          await provider.deleteUser(
                                              users[index].id!, context);
                                        });
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: AppColor.red,
                                    size: 26,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/logout_pop.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/services/provider/authentication.dart';
import 'package:viicsoft_inventory_app/services/provider/userdata.dart';
import 'package:viicsoft_inventory_app/ui/Menu/admin_panel.dart';
import 'package:viicsoft_inventory_app/ui/Menu/user_profile/profile_details_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool status = false;

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    var provider = Provider.of<UserData>(context);
    return Stack(
      children: [
        Container(
          color: Colors.white,
          height: screensize.height,
          width: screensize.width / 1.3,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                color: AppColor.homePageColor,
                height: screensize.height * 0.3,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 30,
                    left: 15,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.buttonText),
                          borderRadius: BorderRadius.circular(130),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(130),
                          child: Image.network(
                            provider.userData.avatar ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(130),
                                child: Image.asset(
                                  'assets/No_image.png',
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            provider.userData.fullName ?? '',
                            style: style.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColor.primaryColor,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            provider.userData.email ?? '',
                            style: style.copyWith(
                              fontSize: 13,
                              color: AppColor.darkGrey,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              ListTile(
                leading:
                    Icon(Icons.person, size: 24, color: AppColor.primaryColor),
                title: Text(
                  'My Profile',
                  style: style.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfileDetailPage(),
                    ),
                  );
                },
              ),
              provider.userData.rolesPriority == 'admin'
                  ? Column(
                      children: [
                        const Divider(),
                        ListTile(
                          leading: Icon(
                            Icons.add_circle_outline,
                            size: 24,
                            color: AppColor.primaryColor,
                          ),
                          title: Text(
                            'Create Event',
                            style: style.copyWith(
                              fontSize: 15,
                            ),
                          ),
                          onTap: () =>
                              Navigator.pushNamed(context, '/addevent'),
                        ),
                      ],
                    )
                  : Container(),
              const Divider(),
              provider.userData.rolesPriority == 'admin'
                  ? ListTile(
                      leading: Icon(
                        Icons.settings_outlined,
                        size: 24,
                        color: AppColor.primaryColor,
                      ),
                      title: Text(
                        'Admin Panel',
                        style: style.copyWith(
                          fontSize: 15,
                        ),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminPanel(),
                        ),
                      ),
                    )
                  : Container(),
              // ListTile(
              //   leading: Icon(
              //     Icons.dark_mode_outlined,
              //     size: 24,
              //     color: AppColor.primaryColor,
              //   ),
              //   title: Text(
              //     'Dark Mode',
              //     style: style.copyWith(
              //       fontSize: 15,
              //     ),
              //   ),
              //   trailing: Switch(
              //     activeColor: AppColor.primaryColor,
              //     materialTapTargetSize: MaterialTapTargetSize.padded,
              //     value: status,
              //     onChanged: (value) {
              //       setState(
              //         () {
              //           status = value;
              //         },
              //       );
              //     },
              //   ),
              // ),
              ListTile(
                leading: Icon(
                  Icons.privacy_tip,
                  size: 24,
                  color: AppColor.primaryColor,
                ),
                title: Text(
                  'Privacy policy',
                  style: style.copyWith(
                    fontSize: 15,
                  ),
                ),
                onTap: () {},
              ),
              const Divider(),
              SizedBox(height: screensize.height * 0.08),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: AppColor.red,
                  size: 24,
                ),
                title: Text(
                  'LogOut',
                  style: style.copyWith(
                    color: AppColor.red,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  handleLogOutAlert(
                    message: 'Are you sure you want to LogOut',
                    context: context,
                    onPressed: () async {
                      Provider.of<Authentication>(context, listen: false)
                          .signOut(context: context);
                    },
                  );
                },
              ),
            ],
          ),
        ),
        Stack(
          children: [
            Positioned(
              right: screensize.width * 0.185,
              top: screensize.height * 0.068,
              child: Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                    color: AppColor.homePageColor,
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: IconButton(
                    onPressed: (() => Navigator.pop(context)),
                    icon: const Icon(
                      Icons.close,
                      size: 26,
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:viicsoft_inventory_app/component/button.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/confirm_password.dart';
import 'package:viicsoft_inventory_app/component/popover.dart';
import 'package:viicsoft_inventory_app/component/profile_update.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/users.dart';
import 'package:viicsoft_inventory_app/services/provider/userdata.dart';

class ProfileDetailPage extends StatefulWidget {
  const ProfileDetailPage({Key? key}) : super(key: key);

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var provider = Provider.of<UserData>(context);
    return Scaffold(
      backgroundColor: AppColor.homePageColor,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        toolbarHeight: 75,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              onPressed: () => {Navigator.pop(context)},
              icon: Icon(
                Icons.arrow_back_ios,
                size: 25,
                color: AppColor.iconBlack,
              ),
            ),
            const SizedBox(width: 16),
            Center(
              child: Text(
                'My Profile',
                style: style.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(flex: 2, child: Container()),
          ],
        ),
      ),
      body: StreamBuilder<Users>(
          stream: provider.fetchUserProfile().asStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var result = snapshot.data!;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Form(
                  key: globalFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView(
                          children: <Widget>[
                            Container(
                              height: screenSize.height * 0.55,
                              width: screenSize.width,
                              decoration: BoxDecoration(
                                  color: AppColor.primaryColor,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 120,
                                          width: 120,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(130),
                                            border: Border.all(
                                                color: AppColor.white,
                                                width: 2),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(130),
                                            child: Image.network(
                                              result.avatar!,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          130),
                                                  child: Image.asset(
                                                    'assets/No_image.png',
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 8,
                                          right: 6,
                                          child: InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (ctx) {
                                                  return provider
                                                          .isupdatingProfileImage
                                                      ? buttonCircularIndicator
                                                      : Popover(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          child:
                                                              Column(children: [
                                                            InkWell(
                                                              onTap: () async {
                                                                Navigator.pop(
                                                                    ctx, false);
                                                                await provider
                                                                    .updateProfileImage(
                                                                  context:
                                                                      context,
                                                                  source:
                                                                      ImageSource
                                                                          .camera,
                                                                );
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  const Icon(Icons
                                                                      .camera_alt_outlined),
                                                                  const SizedBox(
                                                                      width:
                                                                          10),
                                                                  Text(
                                                                      'Take a Pictue',
                                                                      style:
                                                                          style)
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                            const Divider(),
                                                            const SizedBox(
                                                                height: 10),
                                                            InkWell(
                                                              onTap: () async {
                                                                Navigator.pop(
                                                                    ctx, false);
                                                                await provider
                                                                    .updateProfileImage(
                                                                  context:
                                                                      context,
                                                                  source:
                                                                      ImageSource
                                                                          .gallery,
                                                                );
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  const Icon(Icons
                                                                      .photo_library),
                                                                  const SizedBox(
                                                                      width:
                                                                          10),
                                                                  Text(
                                                                      'Select from gallery',
                                                                      style:
                                                                          style)
                                                                ],
                                                              ),
                                                            ),
                                                          ]),
                                                        );
                                                },
                                              );
                                            },
                                            child: Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color: AppColor.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.camera_alt_outlined,
                                                  color: AppColor.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    //
                                    SizedBox(height: screenSize.height * 0.015),
                                    Text(
                                      result.fullName!,
                                      style: style.copyWith(
                                        fontSize: 22,
                                        color: AppColor.white,
                                      ),
                                    ),
                                    SizedBox(height: screenSize.height * 0.005),
                                    Text(
                                      result.email!,
                                      style: style.copyWith(
                                        fontSize: 14,
                                        color: AppColor.darkGrey,
                                      ),
                                    ),

                                    SizedBox(height: screenSize.height * 0.03),
                                    Container(
                                      height: 28,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffEDF9F3),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          result.rolesPriority == 'admin'
                                              ? 'ADMIN'
                                              : 'USER',
                                          style: style.copyWith(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.green,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ),
                                    ),

                                    //
                                    SizedBox(height: screenSize.height * 0.03),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 50),
                                      child: Divider(
                                        color: AppColor.darkGrey,
                                      ),
                                    ),
                                    //
                                    SizedBox(height: screenSize.height * 0.03),

                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (_) {
                                            return ProfileUpdateSheet(
                                              profile: result,
                                              ctx: context,
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        height: 57,
                                        width: 158,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border:
                                              Border.all(color: AppColor.white),
                                        ),
                                        child: Center(
                                            child: Text(
                                          'EDIT PROFILE',
                                          style: style.copyWith(
                                            fontSize: 12,
                                            color: AppColor.buttonText,
                                          ),
                                        )),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            //
                            SizedBox(height: screenSize.height * 0.03),
                            const Divider(),
                            SizedBox(height: screenSize.height * 0.02),
                            Text(
                              'SETTINGS',
                              style: style.copyWith(color: AppColor.darkGrey),
                            ),

                            //
                            SizedBox(height: screenSize.height * 0.03),
                            MainButton(
                              borderColor: AppColor.lightGrey,
                              child: Text(
                                'Change Password',
                                style: style.copyWith(
                                  fontSize: 14,
                                  color: AppColor.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: AppColor.white,
                              onTap: () {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (_) {
                                      return ConfirmPassswordSheet(
                                        profile: result,
                                        ctx: context,
                                      );
                                    });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center();
            }
          }),
    );
  }
}

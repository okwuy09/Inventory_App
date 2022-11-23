import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';

class ProfileChangeSuccessPage extends StatefulWidget {
  const ProfileChangeSuccessPage({Key? key}) : super(key: key);

  @override
  State<ProfileChangeSuccessPage> createState() =>
      _ProfileChangeSuccessPageState();
}

class _ProfileChangeSuccessPageState extends State<ProfileChangeSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.check,
                  size: 150.0,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(child: Container()),
            Text(
              'Profile Update\n Successfully !',
              style: TextStyle(
                fontSize: 30,
                color: AppColor.homePageTitle,
                fontWeight: FontWeight.w400,
              ),
            ),
            Expanded(flex: 2, child: Container()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Continue'),
                  style: ElevatedButton.styleFrom(primary: AppColor.red),
                ),
              ],
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}

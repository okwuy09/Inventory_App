import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool status = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40, left: 10, right: 30),
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Expanded(child: Container()),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'Setting',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                    ),
                  ),
                ),
                Expanded(child: Container()),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 30, right: 30),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    'Dark Mode',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                  Expanded(child: Container()),
                  Switch(
                    activeColor: Colors.green,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    value: status,
                    onChanged: (value) {
                      setState(
                        () {
                          status = value;
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viicsoft_inventory_app/component/button.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/mytextform.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/users.dart';
import 'package:viicsoft_inventory_app/services/provider/userdata.dart';

class ProfileUpdateSheet extends StatefulWidget {
  final Users profile;
  final BuildContext ctx;
  const ProfileUpdateSheet({Key? key, required this.profile, required this.ctx})
      : super(key: key);

  @override
  State<ProfileUpdateSheet> createState() => _ProfileUpdateSheetState();
}

class _ProfileUpdateSheetState extends State<ProfileUpdateSheet> {
  final TextEditingController _newEmail = TextEditingController();
  final TextEditingController _newName = TextEditingController();
  final GlobalKey<FormState> _globalFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    _newName.text = widget.profile.fullName!;
    _newEmail.text = widget.profile.email!;
    super.initState();
  }

  @override
  void dispose() {
    _newName.dispose();
    _newEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserData>(context);
    return Form(
      key: _globalFormKey,
      child: Padding(
        padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //

            Center(
              child: FractionallySizedBox(
                widthFactor: 0.25,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: Container(
                    height: 5.0,
                    decoration: BoxDecoration(
                      color: AppColor.darkGrey,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(2.5)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),

            //
            Text(
              'Full Name',
              style: style.copyWith(
                  fontSize: 12,
                  color: AppColor.darkGrey,
                  fontWeight: FontWeight.bold),
            ),
            MyTextForm(
                controller: _newName,
                labelText: widget.profile.fullName,
                obscureText: false,
                validatior: (input) =>
                    input!.isEmpty ? 'Enter your password' : null),
            //
            const SizedBox(height: 20),
            Text(
              'Email',
              style: style.copyWith(
                  fontSize: 12,
                  color: AppColor.darkGrey,
                  fontWeight: FontWeight.bold),
            ),
            MyTextForm(
              controller: _newEmail,
              labelText: widget.profile.email,
              obscureText: false,
              validatior: (input) => !(input?.contains('@') ?? false)
                  ? "Put a valid Email Address"
                  : null,
            ),
            //

            Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 50),
              child: MainButton(
                borderColor: Colors.transparent,
                child: provider.isupdatingProfile
                    ? buttonCircularIndicator
                    : Text(
                        'UPDATE PROFILE',
                        style: style.copyWith(
                          fontSize: 14,
                          color: AppColor.buttonText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                backgroundColor: AppColor.primaryColor,
                onTap: () async {
                  Navigator.pop(context, false);
                  await provider.updateProfile(
                    context: widget.ctx,
                    email: _newEmail.text,
                    fullname: _newName.text,
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viicsoft_inventory_app/component/button.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/mytextform.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/users.dart';
import 'package:viicsoft_inventory_app/services/provider/userdata.dart';

class ConfirmPassswordSheet extends StatefulWidget {
  final Users profile;
  final BuildContext ctx;
  const ConfirmPassswordSheet(
      {Key? key, required this.profile, required this.ctx})
      : super(key: key);

  @override
  State<ConfirmPassswordSheet> createState() => _ConfirmPassswordSheetState();
}

class _ConfirmPassswordSheetState extends State<ConfirmPassswordSheet> {
  final GlobalKey<FormState> _globalFormKey = GlobalKey<FormState>();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _currentPasswordField = TextEditingController();

  @override
  void dispose() {
    _newPassword.dispose();
    _currentPasswordField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserData>(context);
    return Form(
      key: _globalFormKey,
      child: Padding(
        padding: EdgeInsets.only(
            right: 20,
            left: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: FractionallySizedBox(
                widthFactor: 0.25,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 12.0,
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
            Text(
              'Current password',
              style: style.copyWith(
                  fontSize: 12,
                  color: AppColor.darkGrey,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            MyTextForm(
              controller: _currentPasswordField,
              obscureText: false,
              labelText: 'Current password',
              validatior: (value) {
                bool passValid = RegExp(
                        "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])(?=.*?[!@#\$&*~]).*")
                    .hasMatch(value!);
                if (value.isEmpty || !passValid) {
                  return 'Please enter Valid Pasword*';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Text(
              'New password',
              style: style.copyWith(
                  fontSize: 12,
                  color: AppColor.darkGrey,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            MyTextForm(
              controller: _newPassword,
              obscureText: false,
              labelText: 'New password',
              validatior: (value) {
                bool passValid = RegExp(
                        "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])(?=.*?[!@#\$&*~]).*")
                    .hasMatch(value!);
                if (value.isEmpty || !passValid) {
                  return 'Please enter Valid Pasword*';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 40),
              child: MainButton(
                borderColor: Colors.transparent,
                child: provider.ischangePassword
                    ? buttonCircularIndicator
                    : Text(
                        'DONE',
                        style: style.copyWith(
                          fontSize: 14,
                          color: AppColor.buttonText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                backgroundColor: AppColor.primaryColor,
                onTap: () async {
                  if (_globalFormKey.currentState!.validate()) {
                    Navigator.pop(context, false);
                    await provider.changePassword(
                      _currentPasswordField.text,
                      _newPassword.text,
                      widget.ctx,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/textform.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  bool _isObscure = true;
  bool _isObscure1 = true;
  bool _isObscure2 = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
        child: Column(
          children: [
            SizedBox(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  Expanded(child: Container()),
                  Text(
                    'Reset Password',
                    style: TextStyle(
                      fontSize: 25,
                      color: AppColor.homePageTitle,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Expanded(child: Container()),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(height: 50),
                  Column(
                    children: [
                      textform(
                        obscureText: _isObscure,
                        suffixIcon: IconButton(
                          icon: Icon(_isObscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                        icon: Icons.security,
                        label: 'Current Password',
                      ),
                      const SizedBox(height: 10),
                      textform(
                        obscureText: _isObscure1,
                        suffixIcon: IconButton(
                          icon: Icon(_isObscure1
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure1 = !_isObscure1;
                            });
                          },
                        ),
                        icon: Icons.security,
                        label: 'New Password',
                      ),
                      const SizedBox(height: 10),
                      textform(
                        obscureText: _isObscure2,
                        suffixIcon: IconButton(
                          icon: Icon(_isObscure2
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure2 = !_isObscure2;
                            });
                          },
                        ),
                        icon: Icons.security,
                        label: 'Confirm Password',
                      ),
                    ],
                  ),
                  //const SizedBox(height: 50),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 100, left: 40, right: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, '/PasswordResetSuccessPage');
                      },
                      child: const Text('Update Password'),
                      style: ElevatedButton.styleFrom(primary: AppColor.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

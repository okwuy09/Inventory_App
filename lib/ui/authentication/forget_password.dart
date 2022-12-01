import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viicsoft_inventory_app/component/button.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/mytextform.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/services/provider/authentication.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({
    Key? key,
  }) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

TextEditingController _emailField = TextEditingController();

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _globalFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // used to determined the screen size for responsive design
    var screensize = MediaQuery.of(context).size;
    var provider = Provider.of<Authentication>(context);
    return Scaffold(
      backgroundColor: AppColor.white,
      body: ListView(
        children: [
          Form(
            key: _globalFormKey,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 24.0, right: 24.0, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //navigation button
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColor.black,
                        ),
                      ),

                      SizedBox(height: screensize.height * 0.05),

                      Text(
                        'Password Recovery',
                        style: style.copyWith(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: screensize.height * 0.02),

                      Text(
                        'Enter your registered email below to receive password instructions',
                        style: style.copyWith(color: AppColor.darkGrey),
                      ),

                      SizedBox(height: screensize.height * 0.05),
                      //recovery email form
                      MyTextForm(
                        obscureText: false,
                        autofillHints: const [AutofillHints.email],
                        labelText: 'Email',
                        controller: _emailField,
                        validatior: (input) => !(input?.contains('@') ?? false)
                            ? "Please enter valid Email"
                            : null,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screensize.height * 0.2),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: MainButton(
                        borderColor: Colors.transparent,
                        child: provider.isResetPassword
                            ? buttonCircularIndicator
                            : Text(
                                'SEND VERIFICATION',
                                style: style.copyWith(
                                  fontSize: 14,
                                  color: AppColor.buttonText,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        backgroundColor: AppColor.primaryColor,
                        onTap: () async => await provider.resetPassword(
                            email: _emailField.text, context: context),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

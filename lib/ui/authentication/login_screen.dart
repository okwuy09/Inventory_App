import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viicsoft_inventory_app/component/button.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/mytextform.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/services/provider/authentication.dart';
import 'package:viicsoft_inventory_app/ui/authentication/forget_password.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

TextEditingController _emailField = TextEditingController();
TextEditingController _passwordField = TextEditingController();

class _LoginState extends State<Login> {
  //Data requestModel = Data(email: 'input', pass: 'input');
  final GlobalKey<FormState> _globalFormKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    var provider = Provider.of<Authentication>(context);
    return Scaffold(
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Form(
                key: _globalFormKey,
                child: Column(
                  children: [
                    Container(
                      width: screensize.width,
                      color: AppColor.primaryColor,
                      height: screensize.height / 2.5,
                      child: Center(
                        child: Stack(
                          children: [
                            Image.asset(
                              'assets/Logo.png',
                              width: 135,
                              height: 60,
                            ),
                            Positioned(
                              child: Container(
                                color: AppColor.primaryColor.withOpacity(0.4),
                                width: 135,
                                height: 60,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hi Welcome 👋   ',
                                style: style.copyWith(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.primaryColor,
                                ),
                              ),
                              Text(
                                'Sign in',
                                style: style.copyWith(
                                  color: AppColor.darkGrey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: screensize.height * 0.03),
                              MyTextForm(
                                obscureText: false,
                                labelText: 'Email*',
                                autofillHints: const [AutofillHints.email],
                                controller: _emailField,
                                validatior: (input) =>
                                    !(input?.contains('@') ?? false)
                                        ? "Please enter valid Email"
                                        : null,
                              ),
                              SizedBox(height: screensize.height * 0.03),
                              MyTextForm(
                                obscureText: _isObscure,
                                controller: _passwordField,
                                labelText: 'Password*',
                                validatior: (input) => (input != null &&
                                        input.length < 6)
                                    ? "Password should be more than 5 characters"
                                    : null,
                                suffixIcon: IconButton(
                                    icon: Icon(
                                      _isObscure
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: AppColor.textFormColor,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isObscure = !_isObscure;
                                      });
                                    }),
                              ),
                              SizedBox(height: screensize.height * 0.015),
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const ForgotPassword(),
                                    ),
                                  ),
                                  child: Text(
                                    'Password Recovery',
                                    style: style.copyWith(
                                      fontSize: 14,
                                      color: AppColor.primaryColor
                                          .withOpacity(0.8),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screensize.height * 0.03),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
                              child: MainButton(
                                child: provider.isSignIn
                                    ? buttonCircularIndicator
                                    : Text(
                                        'SIGN IN',
                                        style: style.copyWith(
                                          fontSize: 14,
                                          color: AppColor.buttonText,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                backgroundColor: AppColor.primaryColor,
                                borderColor: Colors.transparent,
                                onTap: () async {
                                  if (_globalFormKey.currentState!.validate()) {
                                    await provider.signIn(
                                      email: _emailField.text,
                                      password: _passwordField.text,
                                      context: context,
                                    );
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'New User?',
                              style: TextStyle(
                                color: AppColor.black,
                                fontSize: 14.0,
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            InkWell(
                              onTap: () async {
                                Navigator.pushNamed(context, '/signup');
                              },
                              child: Text(
                                'Sign Up Here',
                                style: TextStyle(
                                  color: AppColor.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viicsoft_inventory_app/component/button.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/mytextform.dart';
import 'package:viicsoft_inventory_app/component/passwordcheck.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/services/provider/authentication.dart';
import 'package:viicsoft_inventory_app/ui/authentication/login_screen.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _fullNameField = TextEditingController();
  final TextEditingController _emailField = TextEditingController();
  final TextEditingController _passwordField = TextEditingController();
  final TextEditingController _confirmPasswordField = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;
  String onChange = '';

  @override
  void dispose() {
    _fullNameField.dispose();
    _emailField.dispose();
    _passwordField.dispose();
    _confirmPasswordField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    var provider = Provider.of<Authentication>(context);
    return Scaffold(
      backgroundColor: AppColor.white,
      key: _scaffoldKey,
      body: ListView(
        children: [
          Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(20.0, 40.0, 0.0, 0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                            'Sign Up',
                            style: style.copyWith(
                              color: AppColor.darkGrey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screensize.height * 0.01),
                    Container(
                      padding: const EdgeInsets.only(
                          top: 30.0, left: 20.0, right: 20.0),
                      child: Column(
                        children: <Widget>[
                          MyTextForm(
                            controller: _fullNameField,
                            obscureText: false,
                            labelText: 'Fullname*',
                            validatior: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Full Name*';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screensize.height * 0.025),
                          MyTextForm(
                            controller: _emailField,
                            obscureText: false,
                            autofillHints: const [AutofillHints.email],
                            labelText: 'Email*',
                            keyboardType: TextInputType.emailAddress,
                            validatior: (input) => !(input!.isNotEmpty &&
                                    input.contains('@') &&
                                    input.contains('.com'))
                                ? "You have entered a wrong email format"
                                : null,
                          ),
                          SizedBox(height: screensize.height * 0.025),
                          MyTextForm(
                              controller: _passwordField,
                              obscureText: _isObscurePassword,
                              labelText: 'Password*',
                              suffixIcon: IconButton(
                                  icon: Icon(
                                    _isObscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: AppColor.textFormColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isObscurePassword = !_isObscurePassword;
                                    });
                                  }),
                              validatior: (value) {
                                bool passValid = RegExp(
                                        "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])(?=.*?[!@#\$&*~]).*")
                                    .hasMatch(value!);
                                if (value.isEmpty || !passValid) {
                                  return 'Please enter Valid Pasword*';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  onChange = value;
                                });
                              }),
                          SizedBox(height: screensize.height * 0.015),
                          Container(
                            height: 135.0,
                            width: screensize.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: AppColor.primaryColor.withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  PasswordCheck(
                                    isTextEmpty:
                                        onChange.isEmpty ? true : false,
                                    isContained: onChange
                                            .contains(RegExp("(?=.*[a-z]).*"))
                                        ? true
                                        : false,
                                    title:
                                        'Password must contain a small letter',
                                  ),
                                  PasswordCheck(
                                    isTextEmpty:
                                        onChange.isEmpty ? true : false,
                                    isContained: onChange
                                            .contains(RegExp("(?=.*[A-Z]).*"))
                                        ? true
                                        : false,
                                    title:
                                        'Password must contain a capital letter',
                                  ),
                                  PasswordCheck(
                                    isTextEmpty:
                                        onChange.isEmpty ? true : false,
                                    isContained: onChange
                                            .contains(RegExp("(?=.*[0-9]).*"))
                                        ? true
                                        : false,
                                    title:
                                        'Password must contain a number letter',
                                  ),
                                  PasswordCheck(
                                    isTextEmpty:
                                        onChange.isEmpty ? true : false,
                                    isContained: onChange.contains(
                                            RegExp("(?=.*?[!@#\$&*~]).*"))
                                        ? true
                                        : false,
                                    title:
                                        'Password must contain a symbol letter',
                                  ),
                                ]),
                          ),
                          SizedBox(height: screensize.height * 0.025),
                          MyTextForm(
                            controller: _confirmPasswordField,
                            obscureText: _isObscureConfirmPassword,
                            labelText: 'Confirm Password*',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscureConfirmPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColor.textFormColor,
                              ),
                              onPressed: () {
                                setState(
                                  () {
                                    _isObscureConfirmPassword =
                                        !_isObscureConfirmPassword;
                                  },
                                );
                              },
                            ),
                            validatior: (value) {
                              if (_passwordField.text !=
                                  _confirmPasswordField.text) {
                                return 'The passwords do not match, pls verify*';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screensize.height * 0.05),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: MainButton(
                        backgroundColor: AppColor.primaryColor,
                        borderColor: Colors.transparent,
                        child: provider.isSignUp
                            ? buttonCircularIndicator
                            : Text(
                                'SIGN UP',
                                style: style.copyWith(
                                  fontSize: 14,
                                  color: AppColor.buttonText,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        onTap: () async {
                          if (_formkey.currentState!.validate()) {
                            await provider.signUp(
                              email: _emailField.text,
                              password: _passwordField.text,
                              fullName: _fullNameField.text,
                              userName: _fullNameField.text.split('')[0],
                              context: context,
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(height: screensize.height * 0.02),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Have an account already?',
                            style: TextStyle(
                              color: AppColor.black,
                              fontSize: 14.0,
                            ),
                          ),
                          const SizedBox(width: 5.0),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const Login(),
                                ),
                              );
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: AppColor.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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

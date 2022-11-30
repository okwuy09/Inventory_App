import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/buttom_navbar.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/users.dart';
import 'package:viicsoft_inventory_app/ui/authentication/loginsignup_screen.dart';

class Authentication with ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;

  // Reset password
  bool isResetPassword = false;
  Future resetPassword({
    required String email,
    required BuildContext context,
  }) async {
    try {
      isResetPassword = true;
      notifyListeners();
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
      isResetPassword = false;
      notifyListeners();
      successOperation(context);
    } on FirebaseAuthException catch (e) {
      isResetPassword = false;
      notifyListeners();
      return failedOperation(
        context: context,
        message: e.message!,
      );
    }
  }

// signIn function with firebase
  bool isSignIn = false;
  Future<String?> signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      isSignIn = true;
      notifyListeners();
      await _firebaseAuth
          .signInWithEmailAndPassword(
              email: email.trim(), password: password.trim())
          .then(
        (value) {
          if (value.user != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const MyButtomNavigationBar(),
              ),
            );
          }
        },
      );
      isSignIn = false;
      notifyListeners();
      successOperation(context);

      return 'Success';
    } on FirebaseAuthException catch (e) {
      isSignIn = false;
      notifyListeners();
      return failedOperation(
        context: context,
        message: e.message!,
      );
    }
  }

// signUp function with firebase
  bool isSignUp = false;
  Future signUp({
    required String email,
    required String password,
    required String fullName,
    required String userName,
    required BuildContext context,
  }) async {
    try {
      isSignUp = true;
      notifyListeners();
      var _userdata = await _firebaseAuth
          .createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      )
          .then(
        (value) {
          if (value.user != null) {
            /// create profile on signup using Email and password
            final docUser = FirebaseFirestore.instance
                .collection('users')
                .doc(value.user!.uid);
            final user = Users(
              avatar:
                  'https://firebasestorage.googleapis.com/v0/b/nche-application.appspot.com/o/avatar.png?alt=media&token=f70e3f9c-d432-4a03-b047-4ff97a245b52',
              email: email.trim(),
              fullName: fullName.trim(),
              id: docUser.id,
              banned: false,
              dateCreated: DateTime.now(),
              rolesPriority: 'user',
              lastLogin: DateTime.now(),
              username: userName,
            );
            final json = user.toJson();
            //create document and write data to firebase
            docUser.set(json);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const MyButtomNavigationBar(),
              ),
            );
          }
        },
      );

      isSignUp = false;
      notifyListeners();

      successOperation(context);
      // Once signed in, return the UserCredential
      return FirebaseAuth.instance.signInWithCredential(_userdata.credential!);
    } on FirebaseAuthException catch (e) {
      isSignUp = false;
      notifyListeners();
      return failedOperation(
        context: context,
        message: e.message!,
      );
    }
  }

  // signOut fuction with firebase
  Future<void> signOut({required BuildContext context}) async {
    await _firebaseAuth.signOut().then(
          (value) => Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(pageBuilder: (BuildContext context,
                  Animation animation, Animation secondaryAnimation) {
                return const SignupLogin();
              }, transitionsBuilder: (BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              }),
              (Route route) => false),
        );
  }
}

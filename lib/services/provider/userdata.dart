import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/component/success_button_sheet.dart';
import 'package:viicsoft_inventory_app/models/users.dart';
//import 'package:path/path.dart' as paths;

class UserData with ChangeNotifier {
  //bool noProfileUpdate = true;
  Users userData = Users();

  final User _user = FirebaseAuth.instance.currentUser!;
  final _firebaseStorage = FirebaseStorage.instance;
  final _firebaseStore = FirebaseFirestore.instance;
  bool servicestatus = false;
  bool haspermission = false;

  /// fetch user current profile
  Future<Users> fetchUserProfile(context) async {
    var userDoc = await _firebaseStore.collection('users').doc(_user.uid).get();
    _firebaseStore
        .collection('users')
        .doc(_user.uid)
        .snapshots()
        .listen((event) => userData = Users.fromJson(event.data()!));
    notifyListeners();
    return Users.fromJson(userDoc.data()!);
  }

  // Change Password
  bool ischangePassword = false;
  Future changePassword(
    String currentPassword,
    String newPassword,
    BuildContext context,
  ) async {
    //Must re-authenticate user before updating the password. Otherwise it may fail or user get signed out.
    try {
      ischangePassword = true;
      notifyListeners();
      final cred = EmailAuthProvider.credential(
          email: _user.email!, password: currentPassword);
      await _user.reauthenticateWithCredential(cred).then((value) async {
        await _user.updatePassword(newPassword);
      });

      successButtomSheet(
        context: context,
        buttonText: 'BACK TO MY PROFILE',
        title: 'Password Changed\n    Successfully',
        onTap: () => Navigator.pop(context),
      );
      ischangePassword = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      ischangePassword = false;
      notifyListeners();
      return failedOperation(
        context: context,
        message: e.message!,
      );
    }
  }

  // update user profile
  bool isupdatingProfile = false;
  Future updateProfile({
    required BuildContext context,
    required String email,
    required String fullname,
  }) async {
    try {
      isupdatingProfile = true;
      notifyListeners();
      var _userDoc = _firebaseStore;
      _userDoc.collection('users').doc(_user.uid).update({
        'full_name': fullname,
        'email': email,
      });
      successButtomSheet(
          context: context,
          buttonText: 'BACK TO MY PROFILE',
          title: 'Profile Updated\n  Successfully',
          onTap: () => {
                Navigator.pop(context),
              });
      isupdatingProfile = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      isupdatingProfile = false;
      notifyListeners();
      return failedOperation(
        context: context,
        message: e.message!,
      );
    }
  }

// update user profile picture
  bool isupdatingProfileImage = false;
  Future updateProfileImage({
    required ImageSource source,
    XFile? profileImage,
    required BuildContext context,
  }) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 50,
        maxHeight: 700,
        maxWidth: 650,
      );
      isupdatingProfileImage = true;
      profileImage = pickedFile;
      notifyListeners();

      var file = File(profileImage!.path);
      var snapshot = await _firebaseStorage
          .ref()
          .child('images/${profileImage.name}')
          .putFile(file);
      successOperation(context);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      var _userDoc = _firebaseStore;
      _userDoc.collection('users').doc(_user.uid).update({
        'avatar': downloadUrl,
      });

      isupdatingProfileImage = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      isupdatingProfileImage = false;
      notifyListeners();
      return failedOperation(
        context: context,
        message: e.message!,
      );
    }
  }

  // /// apps full data
  // bool isPosting = false;
  // Future writePost({
  //   required String writeUp,
  //   required BuildContext context,
  //   required String location,
  //   required bool isAnonymous,
  //   required String incidentType,
  //   List<File>? avarter,
  //   XFile? camImage,
  // }) async {
  //   try {
  //     isPosting = true;
  //     notifyListeners();
  //     List images = [];

  //     // if the conditions are through upload picture from
  //     // camera and post else send post without image
  //     if (avarter!.isEmpty && camImage != null) {
  //       var file = File(camImage.path);
  //       var snapshot = await _firebaseStorage
  //           .ref()
  //           .child('PostImages/${camImage.path}')
  //           .putFile(file);

  //       var downloadUrl = await snapshot.ref.getDownloadURL();
  //       images.add(downloadUrl);
  //     } else {
  //       for (var img in avarter) {
  //         var snapshot = _firebaseStorage
  //             .ref()
  //             .child('PostImages/${paths.basename(img.path)}');
  //         await snapshot.putFile(img).whenComplete(() async {
  //           var downloadUrl = await snapshot.getDownloadURL();
  //           images.add(downloadUrl);
  //         });
  //       }
  //     }
  //   } on FirebaseAuthException catch (e) {}
  // }
}

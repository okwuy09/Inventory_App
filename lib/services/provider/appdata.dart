import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/category.dart';
import 'package:viicsoft_inventory_app/models/equipmentcheckin.dart';
import 'package:viicsoft_inventory_app/models/equipments.dart';
import 'package:viicsoft_inventory_app/models/eventequipmentcheckout.dart';
import 'package:viicsoft_inventory_app/models/events.dart';

class AppData with ChangeNotifier {
  //final User _user = FirebaseAuth.instance.currentUser!;
  final _firebaseStorage = FirebaseStorage.instance;
  final _firebaseStore = FirebaseFirestore.instance;

  /// Fetch all Event
  Stream<List<Event>> fetchAllEvent() {
    var eventDoc = _firebaseStore
        .collection('event')
        .orderBy('check_in_date', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Event.fromJson(doc.data())).toList());
    return eventDoc;
  }

  /// Fetch all equipment
  Stream<List<EquipmentElement>> fetchAllEquipment() {
    var equipmentDoc = _firebaseStore.collection('equipment').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => EquipmentElement.fromJson(doc.data()))
            .toList());

    return equipmentDoc;
  }

  /// fetch all equipmentCategory
  Stream<List<EquipmentCategory>> fetchAllEquipmentCategory() {
    var categoryDoc = _firebaseStore
        .collection('equipmentCategory')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EquipmentCategory.fromJson(doc.data()))
            .toList());

    return categoryDoc;
  }

  /// Fetch all CheckInEventEquipment
  Stream<List<EventsEquipmentCheckIn>> fetchAllCheckinEquipment() {
    var equipDoc = _firebaseStore
        .collection('checkinEquipment')
        .orderBy('return_datetime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EventsEquipmentCheckIn.fromJson(doc.data()))
            .toList());
    return equipDoc;
  }

  /// Fetch all CheckInEventEquipment
  Stream<List<EventsEquipmentCheckout>> fetchAllCheckOutEquipment() {
    var equipDoc = _firebaseStore
        .collection('checkoutEquipment')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EventsEquipmentCheckout.fromJson(doc.data()))
            .toList());
    return equipDoc;
  }

  // delete event
  Future deleteEvent(String docID, BuildContext context) async {
    await _firebaseStore.collection('event').doc(docID).delete().then(
          (value) => Navigator.pop(context),
        );
    successOperation(context);
    notifyListeners();
  }

  // delete Equipment
  Future deleteEquipment(String docID, BuildContext context) async {
    await _firebaseStore.collection('equipment').doc(docID).delete().then(
          (value) => Navigator.pop(context),
        );
    successOperation(context);
    notifyListeners();
  }

// Delete Category
  Future deleteCategory(String docID, BuildContext context) async {
    await _firebaseStore
        .collection('equipmentCategory')
        .doc(docID)
        .delete()
        .then(
          (value) => Navigator.pop(context),
        );
    successOperation(context);
    notifyListeners();
  }

  // Delete checkinEquipment
  Future deleteCheckinEquipment(String docID, BuildContext context) async {
    await _firebaseStore
        .collection('checkinEquipment')
        .doc(docID)
        .delete()
        .then(
          (value) => Navigator.pop(context),
        );
    successOperation(context);
    notifyListeners();
  }

  // Delete checkinEquipment
  Future deleteCheckOutEquipment(String docID, BuildContext context) async {
    await _firebaseStore
        .collection('checkoutEquipment')
        .doc(docID)
        .delete()
        .then(
          (value) => Navigator.pop(context),
        );
    successOperation(context);
    notifyListeners();
  }

  /// UpdateCheckoutEquipment
  Future updateCheckOutEquipment({
    required BuildContext context,
    required String equipId,
    required String checkinUser,
  }) async {
    try {
      _firebaseStore.collection('checkoutEquipment').doc(equipId).update({
        'is_returned': true,
        'checkOutUserName': checkinUser,
        'equipment_out_datetime': DateTime.now().toIso8601String(),
      });
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      return failedOperation(
        context: context,
        message: e.message!,
      );
    }
  }

  // Update Registered Equipment
  Future updateCheckinEquipment({
    required BuildContext context,
    required String equipmentId,
    required String equipmentCondition,
    required String equipmentDescription,
    XFile? equipmentImage,
  }) async {
    try {
      var file = File(equipmentImage!.path);
      var snapshot = await _firebaseStorage
          .ref()
          .child('equipmentImages/${equipmentImage.path}')
          .putFile(file);

      var downloadUrl = await snapshot.ref.getDownloadURL();
      _firebaseStore.collection('equipment').doc(equipmentId).update({
        'equipment_condition': equipmentCondition,
        'equipment_description': equipmentDescription,
        'equipment_image': downloadUrl,
      });

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      return failedOperation(
        context: context,
        message: e.message!,
      );
    }
  }

  /// Add EventsEquipmentCheckIn
  Future addEventsEquipmentCheckIn({
    required BuildContext context,
    required String eventId,
    required String equipmentId,
    required DateTime returnDatetime,
    required String checkinUserName,
    required String equipmentImage,
    required String equipmentName,
    required String eventName,
    required String equipmentCondition,
  }) async {
    try {
      final docCheckOut = _firebaseStore.collection('checkinEquipment').doc();
      final equipmentCheckout = EventsEquipmentCheckIn(
        id: docCheckOut.id,
        eventId: eventId,
        equipmentId: equipmentId,
        checkinUserName: checkinUserName,
        returnDatetime: returnDatetime,
        equipmentImage: equipmentImage,
        equipmentName: equipmentName,
        eventName: eventName,
        equipmentCondition: equipmentCondition,
      );

      final json = equipmentCheckout.toJson();
      docCheckOut.set(json);
      successOperation(context);
    } on FirebaseAuthException catch (e) {
      return failedOperation(
        context: context,
        message: e.message!,
      );
    }
  }

  /// Add EventsEquipmentCheckout
  Future addEventsEquipmentCheckout({
    required BuildContext context,
    required String eventId,
    required String equipmentId,
    required DateTime equipmentOutDatetime,
    required bool isReturned,
    required String checkOutUserName,
    required String equipmentCondition,
    required String equipmentImage,
    required String equipmentName,
    required String eventName,
  }) async {
    try {
      final docCheckOut =
          _firebaseStore.collection('checkoutEquipment').doc(equipmentId);
      final equipmentCheckout = EventsEquipmentCheckout(
        id: equipmentId,
        eventId: eventId,
        equipmentId: equipmentId,
        equipmentOutDatetime: equipmentOutDatetime,
        isReturned: isReturned,
        checkOutUserName: checkOutUserName,
        equipmentCondition: equipmentCondition,
        equipmentImage: equipmentImage,
        equipmentName: equipmentName,
        eventName: eventName,
      );

      final json = equipmentCheckout.toJson();
      docCheckOut.set(json);
      successOperation(context);
    } on FirebaseAuthException catch (e) {
      return failedOperation(
        context: context,
        message: e.message!,
      );
    }
  }

  //Add Event Equipment
  Future addEventEquipment({
    required String equipmentId,
    required bool ischeckedOut,
    required String eventId,
    required BuildContext context,
  }) async {
    try {
      final eventEquipment =
          EventEquipment(equipmentId: equipmentId, ischeckedOut: ischeckedOut);
      final json = eventEquipment.toJson();
      _firebaseStore.collection('event').doc(eventId).update({
        'event_equipment': FieldValue.arrayUnion([json]),
      });
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      return failedOperation(
        context: context,
        message: e.message!,
      );
    }
  }

  removeEventEquipment({
    required BuildContext context,
    required String equipmentId,
    required bool ischeckedOut,
    required String eventId,
  }) {
    try {
      final usercontact = _firebaseStore.collection('event').doc(eventId);
      // Atomically add a new region to the "regions" array field.
      usercontact.update({
        'event_equipment': FieldValue.arrayRemove([
          {
            'id': equipmentId,
            'ischeckedOut': ischeckedOut,
          }
        ]),
      }).then(
        (value) => Navigator.pop(context),
      );
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      return failedOperation(
        context: context,
        message: e.message!,
      );
    }
  }

  /// update Event Equipment
  updateEventEquipment({
    required String equipmentId,
    required bool ischeckedOut,
    required bool fischeckedOut,
    required String eventId,
    required BuildContext context,
  }) {
    try {
      final usercontact = _firebaseStore.collection('event').doc(eventId);
      // Atomically add a new region to the "regions" array field.
      usercontact.update({
        'event_equipment': FieldValue.arrayRemove([
          {
            'id': equipmentId,
            'ischeckedOut': fischeckedOut,
          }
        ]),
      }).then(
        (value) => notifyListeners(),
      );

      // Atomically remove a region from the "regions" array field.
      usercontact.update({
        'event_equipment': FieldValue.arrayUnion([
          {
            'id': equipmentId,
            'ischeckedOut': ischeckedOut,
          }
        ]),
      }).then(
        (value) => notifyListeners(),
      );
      successOperation(context);
    } on FirebaseAuthException catch (e) {
      return failedOperation(
        context: context,
        message: e.message!,
      );
    }
  }

  /// Update Event
  bool isUpdatingEvent = false;
  Future updateEvent({
    required BuildContext context,
    required String eventName,
    required String eventLocation,
    required String eventType,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required String eventId,
  }) async {
    try {
      isAddingEvent = true;
      notifyListeners();

      _firebaseStore.collection('event').doc(eventId).update({
        'event_name': eventName,
        'event_type': eventType,
        'event_location': eventLocation,
        'check_out_date': checkOutDate.toIso8601String(),
        'check_in_date': checkInDate.toIso8601String(),
      }).then(
        (value) => Navigator.pop(context),
      );
      isUpdatingEvent = false;
      notifyListeners();
      successOperation(context);
    } on FirebaseAuthException catch (e) {
      isUpdatingEvent = false;
      notifyListeners();
      return failedOperation(
        context: context,
        message: e.message!,
      );
    }
  }

  /// Add new Event to the database
  bool isAddingEvent = false;
  Future addNewEvent({
    required BuildContext context,
    required String eventName,
    required String eventLocation,
    required String eventType,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    XFile? eventImage,
  }) async {
    try {
      isAddingEvent = true;
      notifyListeners();

      var file = File(eventImage!.path);
      var snapshot = await _firebaseStorage
          .ref()
          .child('eventImages/${eventImage.path}')
          .putFile(file);

      var downloadUrl = await snapshot.ref.getDownloadURL();

      final docEvent = _firebaseStore.collection('event').doc();
      final event = Event(
        id: docEvent.id,
        checkInDate: checkInDate,
        checkOutDate: checkOutDate,
        eventImage: downloadUrl,
        eventLocation: eventLocation,
        eventName: eventName,
        eventType: eventType,
        eventEquipment: [],
      );

      final json = event.toJson();
      docEvent.set(json);
      isAddingEvent = false;
      notifyListeners();
      Navigator.pop(context);
      successOperation(context);
    } on FirebaseAuthException catch (e) {
      isAddingEvent = false;
      notifyListeners();
      return failedOperation(
        context: context,
        message: e.message!,
      );
    }
  }

  checkedIn(String equipmentId) {
    _firebaseStore.collection('equipment').doc(equipmentId).update({
      'isEquipmentAvialable': true,
    });
  }

  checkedOut(String equipmentId) {
    _firebaseStore.collection('equipment').doc(equipmentId).update({
      'isEquipmentAvialable': false,
    });
  }

  // Update Registered Equipment
  bool isupdatingEquipment = false;
  Future updateEquipment({
    required BuildContext context,
    required String equipmentId,
    required String equipmentName,
    required String equipmentCondition,
    required String equipmentDescription,
  }) async {
    try {
      isupdatingEquipment = true;
      notifyListeners();
      _firebaseStore.collection('equipment').doc(equipmentId).update({
        'equipment_name': equipmentName,
        'equipment_condition': equipmentCondition,
        'equipment_description': equipmentDescription,
      }).then(
        (value) => Navigator.pop(context),
      );

      isupdatingEquipment = false;
      notifyListeners();
      successOperation(context);
    } on FirebaseAuthException catch (e) {
      isupdatingEquipment = false;
      notifyListeners();
      return failedOperation(
        context: context,
        message: e.message!,
      );
    }
  }

  /// Add new Equipment to the database
  bool isAddingEquipment = false;
  Future addNewEquipment({
    required BuildContext context,
    required String equipmentName,
    required String equipmentCondition,
    required String equipmentSize,
    required String equipmentDescription,
    required String equipmentBarcode,
    required String equipmentCategoryId,
    XFile? equipmentImage,
  }) async {
    try {
      isAddingEquipment = true;
      notifyListeners();

      var file = File(equipmentImage!.path);
      var snapshot = await _firebaseStorage
          .ref()
          .child('equipmentImages/${equipmentImage.path}')
          .putFile(file);

      var downloadUrl = await snapshot.ref.getDownloadURL();

      final docEquipment = _firebaseStore.collection('equipment').doc();
      final equipment = EquipmentElement(
        id: docEquipment.id,
        equipmentCategoryId: equipmentCategoryId,
        equipmentCondition: equipmentCondition,
        equipmentImage: downloadUrl,
        equipmentName: equipmentName,
        equipmentSize: equipmentSize,
        equipmentBarcode: equipmentBarcode,
        equipmentDescription: equipmentDescription,
        isEquipmentAvialable: true,
      );

      final json = equipment.toJson();
      docEquipment.set(json);
      isAddingEquipment = false;
      notifyListeners();
      Navigator.pop(context);
      successOperation(context);
    } on FirebaseAuthException catch (e) {
      isAddingEquipment = false;
      notifyListeners();
      return failedOperation(
        context: context,
        message: e.message!,
      );
    }
  }

  /// Create new Equipment category
  bool isCreatingCategory = false;
  Future createEquipmentCategory({
    required BuildContext context,
    required String categoryName,
    XFile? categoryImage,
  }) async {
    try {
      isCreatingCategory = true;
      notifyListeners();
      var file = File(categoryImage!.path);
      var snapshot = await _firebaseStorage
          .ref()
          .child('categoryImages/${categoryImage.path}')
          .putFile(file);

      /// Download the image url after uploading to firebase storage
      var downloadUrl = await snapshot.ref.getDownloadURL();
      final docCategory = _firebaseStore.collection('equipmentCategory').doc();
      final category = EquipmentCategory(
        id: docCategory.id,
        image: downloadUrl,
        name: categoryName,
      );
      // add to the firebase firestore
      final json = category.toJson();
      docCategory.set(json);
      isCreatingCategory = false;
      notifyListeners();
      successOperation(context);
    } on FirebaseAuthException catch (e) {
      isCreatingCategory = false;
      notifyListeners();
      return failedOperation(
        context: context,
        message: e.message!,
      );
    }
  }
}

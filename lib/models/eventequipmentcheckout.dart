// To parse this JSON data, do
//
//     final eventEquipmentCheckOut = eventEquipmentCheckOutFromJson(jsonString);

import 'dart:convert';

EventEquipmentCheckOut eventEquipmentCheckOutFromJson(String str) =>
    EventEquipmentCheckOut.fromJson(json.decode(str));

String eventEquipmentCheckOutToJson(EventEquipmentCheckOut data) =>
    json.encode(data.toJson());

class EventEquipmentCheckOut {
  EventEquipmentCheckOut({
    required this.status,
    required this.message,
    required this.data,
    required this.total,
  });

  bool status;
  String message;
  Data data;
  int total;

  factory EventEquipmentCheckOut.fromJson(Map<String, dynamic> json) =>
      EventEquipmentCheckOut(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
        "total": total,
      };
}

class Data {
  Data({
    required this.eventEquipmentCheckout,
  });

  List<EventsEquipmentCheckout> eventEquipmentCheckout;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        eventEquipmentCheckout: List<EventsEquipmentCheckout>.from(
            json["event_equipment_checkout"]
                .map((x) => EventsEquipmentCheckout.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "event_equipment_checkout":
            List<dynamic>.from(eventEquipmentCheckout.map((x) => x.toJson())),
      };
}

class EventsEquipmentCheckout {
  EventsEquipmentCheckout({
    required this.id,
    required this.eventId,
    required this.equipmentId,
    required this.equipmentOutDatetime,
    required this.isReturned,
    required this.event,
    required this.equipment,
  });

  String id;
  String eventId;
  String equipmentId;
  DateTime equipmentOutDatetime;
  String isReturned;
  Events event;
  Equipment equipment;

  factory EventsEquipmentCheckout.fromJson(Map<String, dynamic> json) =>
      EventsEquipmentCheckout(
        id: json["id"],
        eventId: json["event_id"],
        equipmentId: json["equipment_id"],
        equipmentOutDatetime: DateTime.parse(json["equipment_out_datetime"]),
        isReturned: json["is_returned"],
        event: Events.fromJson(json["event"]),
        equipment: Equipment.fromJson(json["equipment"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "event_id": eventId,
        "equipment_id": equipmentId,
        "equipment_out_datetime": equipmentOutDatetime.toIso8601String(),
        "is_returned": isReturned,
        "event": event.toJson(),
        "equipment": equipment.toJson(),
      };
}

class Equipment {
  Equipment({
    required this.equipmentName,
    required this.equipmentCondition,
    required this.equipmentSize,
    required this.equipmentBarcode,
    required this.equipmentCategoryId,
    required this.equipmentImage,
    required this.category,
  });

  String equipmentName;
  String equipmentCondition;
  String equipmentSize;
  String equipmentBarcode;
  String equipmentCategoryId;
  String equipmentImage;
  Category category;

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
        equipmentName: json["equipment_name"],
        equipmentCondition: json["equipment_condition"],
        equipmentSize: json["equipment_size"],
        equipmentBarcode: json["equipment_barcode"],
        equipmentCategoryId: json["equipment_category_id"],
        equipmentImage: json["equipment_image"],
        category: Category.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "equipment_name": equipmentName,
        "equipment_condition": equipmentCondition,
        "equipment_size": equipmentSize,
        "equipment_barcode": equipmentBarcode,
        "equipment_category_id": equipmentCategoryId,
        "equipment_image": equipmentImage,
        "category": category.toJson(),
      };
}

class Category {
  Category({
    required this.name,
    required this.image,
  });

  String name;
  String image;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
      };
}

class Events {
  Events({
    required this.eventName,
    required this.eventType,
    required this.eventLocation,
    required this.checkInDate,
    required this.checkOutDate,
  });

  String eventName;
  String eventType;
  String eventLocation;
  DateTime checkInDate;
  DateTime checkOutDate;

  factory Events.fromJson(Map<String, dynamic> json) => Events(
        eventName: json["event_name"],
        eventType: json["event_type"],
        eventLocation: json["event_location"],
        checkInDate: DateTime.parse(json["check_in_date"]),
        checkOutDate: DateTime.parse(json["check_out_date"]),
      );

  Map<String, dynamic> toJson() => {
        "event_name": eventName,
        "event_type": eventType,
        "event_location": eventLocation,
        "check_in_date": checkInDate.toIso8601String(),
        "check_out_date": checkOutDate.toIso8601String(),
      };
}

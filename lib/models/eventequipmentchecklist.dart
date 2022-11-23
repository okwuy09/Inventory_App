// To parse this JSON data, do
//
//     final eventEquipmentCheckList = eventEquipmentCheckListFromJson(jsonString);

// ignore_for_file: constant_identifier_names

import 'dart:convert';

EventEquipmentCheckList eventEquipmentCheckListFromJson(String str) =>
    EventEquipmentCheckList.fromJson(json.decode(str));

String eventEquipmentCheckListToJson(EventEquipmentCheckList data) =>
    json.encode(data.toJson());

class EventEquipmentCheckList {
  EventEquipmentCheckList({
    required this.status,
    required this.message,
    required this.data,
    required this.total,
  });

  bool status;
  String message;
  Data data;
  int total;

  factory EventEquipmentCheckList.fromJson(Map<String, dynamic> json) =>
      EventEquipmentCheckList(
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
    required this.eventEquipmentChecklist,
  });

  List<EventEquipmentChecklist> eventEquipmentChecklist;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        eventEquipmentChecklist: List<EventEquipmentChecklist>.from(
            json["event_equipment_checklist"]
                .map((x) => EventEquipmentChecklist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "event_equipment_checklist":
            List<dynamic>.from(eventEquipmentChecklist.map((x) => x.toJson())),
      };
}

class EventEquipmentChecklist {
  EventEquipmentChecklist({
    required this.id,
    required this.eventId,
    required this.equipmentId,
    required this.event,
    required this.equipment,
  });

  String id;
  String eventId;
  String equipmentId;
  CheckListEvents event;
  Equipment equipment;

  factory EventEquipmentChecklist.fromJson(Map<String, dynamic> json) =>
      EventEquipmentChecklist(
        id: json["id"],
        eventId: json["event_id"],
        equipmentId: json["equipment_id"],
        event: CheckListEvents.fromJson(json["event"]),
        equipment: Equipment.fromJson(json["equipment"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "event_id": eventId,
        "equipment_id": equipmentId,
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
  EquipmentSize? equipmentSize;
  String equipmentBarcode;
  String equipmentCategoryId;
  String equipmentImage;
  Category category;

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
        equipmentName: json["equipment_name"],
        equipmentCondition: json["equipment_condition"],
        equipmentSize: equipmentSizeValues.map![json["equipment_size"]],
        equipmentBarcode: json["equipment_barcode"],
        equipmentCategoryId: json["equipment_category_id"],
        equipmentImage: json["equipment_image"],
        category: Category.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "equipment_name": equipmentName,
        "equipment_condition": equipmentCondition,
        "equipment_size": equipmentSizeValues.reverse[equipmentSize],
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

enum EquipmentSize { SHORT, VERY_LONG, LONG }

final equipmentSizeValues = EnumValues({
  "LONG": EquipmentSize.LONG,
  "SHORT": EquipmentSize.SHORT,
  "VERY LONG": EquipmentSize.VERY_LONG
});

class CheckListEvents {
  CheckListEvents({
    required this.eventName,
    required this.eventType,
    required this.eventLocation,
    required this.checkInDate,
    required this.checkOutDate,
  });

  EventName? eventName;
  EventType? eventType;
  EventLocation? eventLocation;
  DateTime checkInDate;
  DateTime checkOutDate;

  factory CheckListEvents.fromJson(Map<String, dynamic> json) =>
      CheckListEvents(
        eventName: eventNameValues.map![json["event_name"]],
        eventType: eventTypeValues.map![json["event_type"]],
        eventLocation: eventLocationValues.map![json["event_location"]],
        checkInDate: DateTime.parse(json["check_in_date"]),
        checkOutDate: DateTime.parse(json["check_out_date"]),
      );

  Map<String, dynamic> toJson() => {
        "event_name": eventNameValues.reverse[eventName],
        "event_type": eventTypeValues.reverse[eventType],
        "event_location": eventLocationValues.reverse[eventLocation],
        "check_in_date": checkInDate.toIso8601String(),
        "check_out_date": checkOutDate.toIso8601String(),
      };
}

enum EventLocation { ENUGU }

final eventLocationValues = EnumValues({"Enugu": EventLocation.ENUGU});

enum EventName { EMENE_INTRODUCTION, OBIORA_NWAUDE_WEDDING }

final eventNameValues = EnumValues({
  "emene introduction": EventName.EMENE_INTRODUCTION,
  "obiora nwaude wedding": EventName.OBIORA_NWAUDE_WEDDING
});

enum EventType { CEREMONY, WEDDING }

final eventTypeValues =
    EnumValues({"Ceremony": EventType.CEREMONY, "wedding": EventType.WEDDING});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap ??= map!.map((k, v) => MapEntry(v, k));
    return reverseMap!;
  }
}

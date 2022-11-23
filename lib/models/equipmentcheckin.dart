// To parse this JSON data, do
//
//     final equipmentCheckIn = equipmentCheckInFromJson(jsonString);

import 'dart:convert';

EquipmentCheckIn equipmentCheckInFromJson(String str) => EquipmentCheckIn.fromJson(json.decode(str));

String equipmentCheckInToJson(EquipmentCheckIn data) => json.encode(data.toJson());

class EquipmentCheckIn {
    EquipmentCheckIn({
        required this.status,
        required this.message,
        required this.data,
        required this.total,
    });

    bool status;
    String message;
    Data data;
    int total;

    factory EquipmentCheckIn.fromJson(Map<String, dynamic> json) => EquipmentCheckIn(
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
        required this.equipmentCheckin,
    });

    List<EquipmentsCheckin> equipmentCheckin;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        equipmentCheckin: List<EquipmentsCheckin>.from(json["equipment_checkin"].map((x) => EquipmentsCheckin.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "equipment_checkin": List<dynamic>.from(equipmentCheckin.map((x) => x.toJson())),
    };
}

class EquipmentsCheckin {
    EquipmentsCheckin({
        required this.id,
        required this.equipmentId,
        required this.equipmentInDatetime,
        required this.event,
        required this.equipment,
    });

    String id;
    String equipmentId;
    DateTime equipmentInDatetime;
    dynamic event;
    Equipment equipment;

    factory EquipmentsCheckin.fromJson(Map<String, dynamic> json) => EquipmentsCheckin(
        id: json["id"],
        equipmentId: json["equipment_id"],
        equipmentInDatetime: DateTime.parse(json["equipment_in_datetime"]),
        event: json["event"],
        equipment: Equipment.fromJson(json["equipment"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "equipment_id": equipmentId,
        "equipment_in_datetime": equipmentInDatetime.toIso8601String(),
        "event": event,
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

// To parse this JSON data, do
//
//     final equipment = equipmentFromJson(jsonString);

import 'dart:convert';

Equipment equipmentFromJson(String str) => Equipment.fromJson(json.decode(str));

String equipmentToJson(Equipment data) => json.encode(data.toJson());

class Equipment {
  Equipment({
    required this.status,
    required this.message,
    required this.data,
    required this.total,
  });

  bool status;
  String message;
  Data data;
  int total;

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
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
    required this.equipments,
  });

  List<EquipmentElement> equipments;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        equipments: List<EquipmentElement>.from(
            json["equipments"].map((x) => EquipmentElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "equipments": List<dynamic>.from(equipments.map((x) => x.toJson())),
      };
}

class EquipmentElement {
  EquipmentElement({
    required this.id,
    required this.equipmentName,
    required this.equipmentCondition,
    required this.equipmentSize,
    this.equipmentDescription,
    this.equipmentBarcode,
    required this.equipmentCategoryId,
    required this.equipmentImage,
  });

  String id;
  String equipmentName;
  String equipmentCondition;
  String equipmentSize;
  String? equipmentDescription;
  String? equipmentBarcode;
  String equipmentCategoryId;
  String equipmentImage;

  factory EquipmentElement.fromJson(Map<String, dynamic> json) =>
      EquipmentElement(
        id: json["id"],
        equipmentName: json["equipment_name"],
        equipmentCondition: json["equipment_condition"],
        equipmentSize: json["equipment_size"],
        // ignore: prefer_if_null_operators
        equipmentDescription: json["equipment_description"] == null
            ? null
            : json["equipment_description"],
        // ignore: prefer_if_null_operators
        equipmentBarcode: json["equipment_barcode"] == null
            ? null
            : json["equipment_barcode"],
        equipmentCategoryId: json["equipment_category_id"],
        equipmentImage: json["equipment_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "equipment_name": equipmentName,
        "equipment_condition": equipmentCondition,
        "equipment_size": equipmentSize,
        // ignore: prefer_if_null_operators
        "equipment_description":
            // ignore: prefer_if_null_operators
            equipmentDescription == null ? null : equipmentDescription,
        // ignore: prefer_if_null_operators
        "equipment_barcode": equipmentBarcode == null ? null : equipmentBarcode,
        "equipment_category_id": equipmentCategoryId,
        "equipment_image": equipmentImage,
      };
}

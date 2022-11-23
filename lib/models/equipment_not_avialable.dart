// To parse this JSON data, do
//
//     final equipmentsNotAvailable = equipmentsNotAvailableFromJson(jsonString);

import 'dart:convert';

EquipmentsNotAvailable equipmentsNotAvailableFromJson(String str) => EquipmentsNotAvailable.fromJson(json.decode(str));

String equipmentsNotAvailableToJson(EquipmentsNotAvailable data) => json.encode(data.toJson());

class EquipmentsNotAvailable {
    EquipmentsNotAvailable({
        required this.status,
        required this.message,
        required this.data,
        required this.total,
    });

    bool status;
    String message;
    Data data;
    int total;

    factory EquipmentsNotAvailable.fromJson(Map<String, dynamic> json) => EquipmentsNotAvailable(
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
        required this.equipmentsNotAvailable,
    });

    List<EquipmentsNotAvailableElement> equipmentsNotAvailable;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        equipmentsNotAvailable: List<EquipmentsNotAvailableElement>.from(json["equipments_not_available"].map((x) => EquipmentsNotAvailableElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "equipments_not_available": List<dynamic>.from(equipmentsNotAvailable.map((x) => x.toJson())),
    };
}

class EquipmentsNotAvailableElement {
    EquipmentsNotAvailableElement({
        required this.equipmentName,
        required this.equipmentId,
        required this.equipmentCondition,
        required this.equipmentBarcode,
        required this.equipmentImage,
        required this.equipmentCategoryId,
        required this.checkoutDate,
        required this.eventName,
        required this.eventId,
    });

    String equipmentName;
    String equipmentId;
    String equipmentCondition;
    String equipmentBarcode;
    String equipmentImage;
    String equipmentCategoryId;
    DateTime checkoutDate;
    String eventName;
    String eventId;

    factory EquipmentsNotAvailableElement.fromJson(Map<String, dynamic> json) => EquipmentsNotAvailableElement(
        equipmentName: json["equipment_name"],
        equipmentId: json["equipment_id"],
        equipmentCondition: json["equipment_condition"],
        equipmentBarcode: json["equipment_barcode"],
        equipmentImage: json["equipment_image"],
        equipmentCategoryId: json["equipment_category_id"],
        checkoutDate: DateTime.parse(json["checkout_date"]),
        eventName: json["event_name"],
        eventId: json["event_id"],
    );

    Map<String, dynamic> toJson() => {
        "equipment_name": equipmentName,
        "equipment_id": equipmentId,
        "equipment_condition": equipmentCondition,
        "equipment_barcode": equipmentBarcode,
        "equipment_image": equipmentImage,
        "equipment_category_id": equipmentCategoryId,
        "checkout_date": checkoutDate.toIso8601String(),
        "event_name": eventName,
        "event_id": eventId,
    };
}

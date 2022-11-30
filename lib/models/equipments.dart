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
    required this.isEquipmentAvialable,
  });

  String id;
  String equipmentName;
  String equipmentCondition;
  String equipmentSize;
  String? equipmentDescription;
  String? equipmentBarcode;
  String equipmentCategoryId;
  String equipmentImage;
  bool isEquipmentAvialable;

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
        isEquipmentAvialable: json["isEquipmentAvialable"],
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
        "isEquipmentAvialable": isEquipmentAvialable,
      };
}

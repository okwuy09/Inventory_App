// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);
import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String welcomeToJson(Category data) => json.encode(data.toJson());

class Category {
    Category({
        required this.status,
        required this.message,
        required this.data,
        required this.total,
    });

    bool status;
    String message;
    Data data;
    int total;

    factory Category.fromJson(Map<String, dynamic> json) => Category(
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
        required this.equipmentCategory,
    });

    List<EquipmentCategory> equipmentCategory;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        equipmentCategory: List<EquipmentCategory>.from(json["equipment_category"].map((x) => EquipmentCategory.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "equipment_category": List<dynamic>.from(equipmentCategory.map((x) => x.toJson())),
    };
}

class EquipmentCategory {
    EquipmentCategory({
        required this.id,
        required this.name,
        required this.image,
    });

    String id;
    String name;
    String image;

    factory EquipmentCategory.fromJson(Map<String, dynamic> json) => EquipmentCategory(
        id: json["id"],
        name: json["name"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
    };
}

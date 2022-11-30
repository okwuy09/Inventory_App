class EquipmentCategory {
  EquipmentCategory({
    required this.id,
    required this.name,
    required this.image,
  });

  String id;
  String name;
  String image;

  factory EquipmentCategory.fromJson(Map<String, dynamic> json) =>
      EquipmentCategory(
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

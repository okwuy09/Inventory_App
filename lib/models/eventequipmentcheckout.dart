class EventsEquipmentCheckout {
  EventsEquipmentCheckout({
    required this.id,
    required this.eventId,
    required this.equipmentId,
    required this.equipmentOutDatetime,
    required this.isReturned,
    required this.checkOutUserName,
    required this.equipmentCondition,
    required this.equipmentImage,
    required this.equipmentName,
    required this.eventName,
  });

  String id;
  String eventId;
  String equipmentId;
  DateTime equipmentOutDatetime;
  bool isReturned;
  String equipmentImage;
  String equipmentName;
  String eventName;
  String equipmentCondition;
  String checkOutUserName;

  factory EventsEquipmentCheckout.fromJson(Map<String, dynamic> json) =>
      EventsEquipmentCheckout(
        id: json["id"],
        eventId: json["event_id"],
        equipmentId: json["equipment_id"],
        equipmentOutDatetime: DateTime.parse(json["equipment_out_datetime"]),
        isReturned: json["is_returned"],
        checkOutUserName: json["checkOutUserName"],
        equipmentCondition: json["equipmentCondition"],
        equipmentImage: json["equipmentImage"],
        equipmentName: json["equipmentName"],
        eventName: json["eventName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "event_id": eventId,
        "equipment_id": equipmentId,
        "equipment_out_datetime": equipmentOutDatetime.toIso8601String(),
        "is_returned": isReturned,
        "checkOutUserName": checkOutUserName,
        "equipmentCondition": equipmentCondition,
        "equipmentImage": equipmentImage,
        "equipmentName": equipmentName,
        "eventName": eventName,
      };
}

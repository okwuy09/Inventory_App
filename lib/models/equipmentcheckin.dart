class EventsEquipmentCheckIn {
  EventsEquipmentCheckIn({
    required this.id,
    required this.eventId,
    required this.equipmentId,
    required this.checkinUserName,
    required this.returnDatetime,
    required this.equipmentImage,
    required this.equipmentName,
    required this.eventName,
    required this.equipmentCondition,
  });

  String id;
  String eventId;
  String equipmentId;
  String equipmentImage;
  String equipmentName;
  String eventName;
  String equipmentCondition;
  DateTime returnDatetime;
  String checkinUserName;

  factory EventsEquipmentCheckIn.fromJson(Map<String, dynamic> json) =>
      EventsEquipmentCheckIn(
        id: json["id"],
        eventId: json["event_id"],
        equipmentId: json["equipment_id"],
        returnDatetime: DateTime.parse(json["return_datetime"]),
        checkinUserName: json["checkinUserName"],
        equipmentImage: json["equipmentImage"],
        equipmentName: json["equipmentName"],
        eventName: json["eventName"],
        equipmentCondition: json["equipmentCondition"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "event_id": eventId,
        "equipment_id": equipmentId,
        "return_datetime": returnDatetime.toIso8601String(),
        "checkinUserName": checkinUserName,
        "equipmentImage": equipmentImage,
        "equipmentName": equipmentName,
        "eventName": eventName,
        "equipmentCondition": equipmentCondition,
      };
}

class Event {
  Event({
    required this.id,
    required this.eventName,
    required this.eventType,
    required this.eventLocation,
    required this.checkInDate,
    required this.checkOutDate,
    required this.eventImage,
    required this.eventEquipment,
  });

  String id;
  String eventName;
  String eventType;
  String eventLocation;
  DateTime checkInDate;
  DateTime checkOutDate;
  String eventImage;
  List<EventEquipment> eventEquipment;

  factory Event.fromJson(Map<String, dynamic> json) {
    final eventEquipment = json['event_equipment'] as List;
    return Event(
      id: json["id"],
      eventName: json["event_name"],
      eventType: json["event_type"],
      eventLocation: json["event_location"],
      checkInDate: DateTime.parse(json["check_in_date"]),
      checkOutDate: DateTime.parse(json["check_out_date"]),
      eventImage: json["event_image"],
      eventEquipment:
          eventEquipment.map((data) => EventEquipment.fromJson(data)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "event_name": eventName,
        "event_type": eventType,
        "event_location": eventLocation,
        "check_in_date": checkInDate.toIso8601String(),
        "check_out_date": checkOutDate.toIso8601String(),
        "event_image": eventImage,
        "event_equipment": eventEquipment.map((e) => e.toJson()).toList(),
      };
}

class EventEquipment {
  String equipmentId;
  bool ischeckedOut;
  EventEquipment({
    required this.equipmentId,
    required this.ischeckedOut,
  });

  Map<String, dynamic> toJson() => {
        'id': equipmentId,
        'ischeckedOut': ischeckedOut,
      };

  factory EventEquipment.fromJson(Map<String, dynamic> json) => EventEquipment(
        equipmentId: json['id'],
        ischeckedOut: json['ischeckedOut'],
      );
}

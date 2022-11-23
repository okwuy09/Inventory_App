import 'dart:convert';

Events eventsFromJson(String str) => Events.fromJson(json.decode(str));

String eventsToJson(Events data) => json.encode(data.toJson());

class Events {
  Events({
    required this.status,
    required this.message,
    required this.data,
    required this.total,
  });

  bool status;
  String message;
  Data data;
  int total;

  factory Events.fromJson(Map<String, dynamic> json) => Events(
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
    required this.events,
  });

  List<Event> events;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    events: List<Event>.from(json["events"].map((x) => Event.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "events": List<dynamic>.from(events.map((x) => x.toJson())),
  };
}

class Event {
  Event({
    required this.id,
    required this.eventName,
    required this.eventType,
    required this.eventLocation,
    required this.checkInDate,
    required this.checkOutDate,
    required this.eventImage,
  });

  String id;
  String eventName;
  String eventType;
  String eventLocation;
  DateTime checkInDate;
  DateTime checkOutDate;
  String eventImage;

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json["id"],
    eventName: json["event_name"],
    eventType: json["event_type"],
    eventLocation: json["event_location"],
    checkInDate: DateTime.parse(json["check_in_date"]),
    checkOutDate: DateTime.parse(json["check_out_date"]),
    eventImage: json["event_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "event_name": eventName,
    "event_type": eventType,
    "event_location": eventLocation,
    "check_in_date": checkInDate.toIso8601String(),
    "check_out_date": checkOutDate.toIso8601String(),
    "event_image": eventImage,
  };
}

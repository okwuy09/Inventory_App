// To parse this JSON data, do
//
//     final pastEvent = pastEventFromJson(jsonString);
import 'dart:convert';

PastEvent pastEventFromJson(String str) => PastEvent.fromJson(json.decode(str));

String pastEventToJson(PastEvent data) => json.encode(data.toJson());

class PastEvent {
    PastEvent({
        required this.status,
        required this.message,
        required this.data,
        required this.total,
    });

    bool status;
    String message;
    Data data;
    int total;

    factory PastEvent.fromJson(Map<String, dynamic> json) => PastEvent(
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
        required this.eventsPast,
    });

    List<EventsPast> eventsPast;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        eventsPast: List<EventsPast>.from(json["events_past"].map((x) => EventsPast.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "events_past": List<dynamic>.from(eventsPast.map((x) => x.toJson())),
    };
}

class EventsPast {
    EventsPast({
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

    factory EventsPast.fromJson(Map<String, dynamic> json) => EventsPast(
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

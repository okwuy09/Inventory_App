// To parse this JSON data, do
//
//     final futureEvent = futureEventFromJson(jsonString);
import 'dart:convert';

FutureEvent futureEventFromJson(String str) => FutureEvent.fromJson(json.decode(str));

String futureEventToJson(FutureEvent data) => json.encode(data.toJson());

class FutureEvent {
    FutureEvent({
        required this.status,
        required this.message,
        required this.data,
        required this.total,
    });

    bool status;
    String message;
    Data data;
    int total;

    factory FutureEvent.fromJson(Map<String, dynamic> json) => FutureEvent(
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
        required this.eventsFuture,
    });

    List<EventsFuture> eventsFuture;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        eventsFuture: List<EventsFuture>.from(json["events_future"].map((x) => EventsFuture.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "events_future": List<dynamic>.from(eventsFuture.map((x) => x.toJson())),
    };
}

class EventsFuture {
    EventsFuture({
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

    factory EventsFuture.fromJson(Map<String, dynamic> json) => EventsFuture(
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

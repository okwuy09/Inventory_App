import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:viicsoft_inventory_app/models/events.dart';
import 'package:viicsoft_inventory_app/models/future_event.dart';
import 'package:viicsoft_inventory_app/models/pastevent.dart';
import 'package:viicsoft_inventory_app/services/sharedpref.dart';
import '../api.dart';

class EventAPI extends BaseAPI {
  Future<List<Event>> fetchAllEvents() async {
    final response =
        await http.get(Uri.parse(super.allEventsPath), headers: super.headers);

    if (response.statusCode == 200) {
      final _data = jsonDecode(response.body);
      final List<Event> events = _data['data']['events']
          .map<Event>((model) => Event.fromJson(model as Map<String, dynamic>))
          .toList();
      return events;
    } else {
      throw Exception('Failed to load Events');
    }
  }

  Future<List<EventsFuture>> fetchFutureEvents() async {
    final String token = await SharedPrefrence().getToken();
    final response =
        await http.get(Uri.parse(super.allFutureEventsPath), headers: {
      "X-Api-Key": "632F2EC9771B6C4C0BDF30BE21D9009B",
      'x-token': token,
    });

    if (response.statusCode == 200) {
      final _data = jsonDecode(response.body);
      final List<EventsFuture> events = _data['data']['events_future']
          .map<EventsFuture>(
              (model) => EventsFuture.fromJson(model as Map<String, dynamic>))
          .toList();
      return events;
    } else {
      throw Exception('Failed to load Future Events');
    }
  }

  Future<List<EventsPast>> fetchPastEvents() async {
    final String token = await SharedPrefrence().getToken();
    final response =
        await http.get(Uri.parse(super.allPastEventsPath), headers: {
      "X-Api-Key": "632F2EC9771B6C4C0BDF30BE21D9009B",
      'x-token': token,
    });

    if (response.statusCode == 200) {
      final _data = jsonDecode(response.body);
      final List<EventsPast> events = _data['data']['events_past']
          .map<EventsPast>(
              (model) => EventsPast.fromJson(model as Map<String, dynamic>))
          .toList();
      return events;
    } else {
      throw Exception('Failed to load Past Events');
    }
  }

  Future<http.StreamedResponse> addEvent(
      String eventName,
      XFile eventImage,
      String eventType,
      String eventLocation,
      String checkinDate,
      String checkOutDate) async {
    final String token = await SharedPrefrence().getToken();
    Map<String, String> headers = {
      "X-Api-Key": "632F2EC9771B6C4C0BDF30BE21D9009B",
      'x-token': token,
    };
    //create multipart request for POST or PATCH method
    var request = http.MultipartRequest("POST", Uri.parse(super.addEventsPath));
    //add header in http request
    request.headers.addAll(headers);

    //add text fields
    request.fields["event_name"] = eventName;
    request.fields["event_type"] = eventType;
    request.fields["event_location"] = eventLocation;
    request.fields["check_in_date"] = checkinDate;
    request.fields["check_out_date"] = checkOutDate;
    //create multipart using filepath, string or bytes
    var pic = await http.MultipartFile.fromPath("event_image", eventImage.path);
    //add multipart to request
    request.files.add(pic);
    var response = await request.send();
    return response;
  }

  Future<http.StreamedResponse> updateEvent(
      String eventName,
      // XFile eventImage,
      String eventType,
      String eventLocation,
      String checkinDate,
      String checkOutDate,
      String id) async {
    final String token = await SharedPrefrence().getToken();
    Map<String, String> headers = {
      "X-Api-Key": "632F2EC9771B6C4C0BDF30BE21D9009B",
      'x-token': token,
    };
    var request =
        http.MultipartRequest("POST", Uri.parse(super.upDateEventsPath));
    request.headers.addAll(headers);
    request.fields["event_name"] = eventName;
    request.fields["event_type"] = eventType;
    request.fields["event_location"] = eventLocation;
    request.fields["check_in_date"] = checkinDate;
    request.fields["check_out_date"] = checkOutDate;
    request.fields["id"] = id;
    // var pic = await http.MultipartFile.fromPath("event_image", eventImage.path);
    // request.files.add(pic);
    var response = await request.send();
    return response;
  }

  Future<http.Response> addEventEquipment(
      String eventId, String equipmentId) async {
    final String token = await SharedPrefrence().getToken();
    var body = jsonEncode({'event_id': eventId, 'equipment_id': equipmentId});
    http.Response response =
        await http.post(Uri.parse(super.addEventEquipmentsChecklistPath),
            headers: {
              "X-Api-Key": "632F2EC9771B6C4C0BDF30BE21D9009B",
              'x-token': token,
            },
            body: body);

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed auth');
    }
  }

  Future<http.Response> deleteEvent(String id) async {
    final String token = await SharedPrefrence().getToken();

    var body = jsonEncode({'id': id});
    final http.Response response =
        await http.post(Uri.parse(super.deleteEventsPath + id),
            headers: <String, String>{
              "X-Api-Key": "632F2EC9771B6C4C0BDF30BE21D9009B",
              "Content-Type": "application/json",
              'Accept': 'application/json',
              'x-token': token,
            },
            body: body);
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to delete Event.');
    }
  }
}

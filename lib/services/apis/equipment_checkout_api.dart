import 'dart:convert';

import 'package:viicsoft_inventory_app/services/api.dart';
import 'package:http/http.dart' as http;
import '../../models/eventequipmentcheckout.dart';
import '../sharedpref.dart';

class EquipmentCheckOutAPI extends BaseAPI {
  Future<List<EventsEquipmentCheckout>> fetchAllEquipmentCheckOut() async {
    final String token = await SharedPrefrence().getToken();
    final response =
        await http.get(Uri.parse(super.allEquipmemntCheckOutPath), headers: {
      "X-Api-Key": "632F2EC9771B6C4C0BDF30BE21D9009B",
      "Content-Type": "application/json",
      'Accept': 'application/json',
      'x-token': token,
    });

    if (response.statusCode == 200) {
      final _data = jsonDecode(response.body);
      final List<EventsEquipmentCheckout> equipments = _data['data']
              ['event_equipment_checkout']
          .map<EventsEquipmentCheckout>((model) =>
              EventsEquipmentCheckout.fromJson(model as Map<String, dynamic>))
          .toList();
      return equipments;
    } else {
      throw Exception('Failed to load Events');
    }
  }

  Future<http.Response> checkoutEquipments(
      String eventId, String equipmentId) async {
    final String token = await SharedPrefrence().getToken();

    var body = jsonEncode({
      'event_id': eventId,
      'equipment_id': equipmentId,
    });
    final http.Response response =
        await http.post(Uri.parse(super.checkoutEquipmentsPath),
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
      throw Exception('Failed to Add Equipment to CheckList.');
    }
  }

  Future<http.Response> deleteEventEquipmentCheckout(String id) async {
    final String token = await SharedPrefrence().getToken();

    var body = jsonEncode({'id': id});
    final http.Response response =
        await http.post(Uri.parse(super.deleteEventsEquipmentChechoutPath),
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
      throw Exception('Failed to Delete Equipment.');
    }
  }
}

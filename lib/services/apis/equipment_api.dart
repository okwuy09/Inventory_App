import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:viicsoft_inventory_app/models/avialable_equipment.dart';
import 'package:viicsoft_inventory_app/models/equipment_not_avialable.dart';
import 'package:viicsoft_inventory_app/models/equipments.dart';
import 'package:viicsoft_inventory_app/services/api.dart';
import 'package:http/http.dart' as http;
import '../sharedpref.dart';

class EquipmentAPI extends BaseAPI {
  Future<List<EquipmentElement>> fetchAllEquipments() async {
    final String token = await SharedPrefrence().getToken();

    final response =
        await http.get(Uri.parse(super.allEquipmentsPath), headers: {
      "X-Api-Key": "632F2EC9771B6C4C0BDF30BE21D9009B",
      "Content-Type": "application/json",
      'Accept': 'application/json',
      'x-token': token,
    });

    if (response.statusCode == 200) {
      final _data = jsonDecode(response.body);
      final List<EquipmentElement> equipments = _data['data']['equipments']
          .map<EquipmentElement>((model) =>
              EquipmentElement.fromJson(model as Map<String, dynamic>))
          .toList();
      return equipments;
    } else {
      throw Exception('Failed to load Equipments');
    }
  }

  Future<List<EquipmentsAvailable>> fetchAvialableEquipments() async {
    final String token = await SharedPrefrence().getToken();
    final response =
        await http.get(Uri.parse(super.avialableEquipmentsPath), headers: {
      "X-Api-Key": "632F2EC9771B6C4C0BDF30BE21D9009B",
      "Content-Type": "application/json",
      'Accept': 'application/json',
      'x-token': token,
    });

    if (response.statusCode == 200) {
      final _data = jsonDecode(response.body);
      final List<EquipmentsAvailable> avialableequipments = _data['data']
              ['equipments_available']
          .map<EquipmentsAvailable>((model) =>
              EquipmentsAvailable.fromJson(model as Map<String, dynamic>))
          .toList();
      return avialableequipments;
    } else {
      throw Exception('Failed to load equipments available');
    }
  }

  Future<List<EquipmentsNotAvailableElement>>
      fetchEquipmentsNotAvialable() async {
    final String token = await SharedPrefrence().getToken();

    final response =
        await http.get(Uri.parse(super.notAvialableEquipmentsPath), headers: {
      "X-Api-Key": "632F2EC9771B6C4C0BDF30BE21D9009B",
      "Content-Type": "application/json",
      'Accept': 'application/json',
      'x-token': token,
    });
    if (response.statusCode == 200) {
      final _data = jsonDecode(response.body);
      final List<EquipmentsNotAvailableElement> equipments = _data['data']
              ['equipments_not_available']
          .map<EquipmentsNotAvailableElement>((model) =>
              EquipmentsNotAvailableElement.fromJson(
                  model as Map<String, dynamic>))
          .toList();
      return equipments;
    } else {
      throw Exception('Failed to load equipments available');
    }
  }

  Future<http.StreamedResponse> addEquipment(
      String newEquipmentName,
      XFile newImage,
      String newCategoryId,
      String newCondition,
      String newSize,
      String newDescription,
      String newBarcode) async {
    final String token = await SharedPrefrence().getToken();
    Map<String, String> headers = {
      "X-Api-Key": "632F2EC9771B6C4C0BDF30BE21D9009B",
      'x-token': token,
    };
    //create multipart request for POST or PATCH method
    var request =
        http.MultipartRequest("POST", Uri.parse(super.addEquipmentsPath));
    //add header in http request
    request.headers.addAll(headers);

    //add text fields
    request.fields["equipment_name"] = newEquipmentName;
    request.fields["equipment_condition"] = newCondition;
    request.fields["equipment_size"] = newSize;
    request.fields["equipment_description"] = newDescription;
    request.fields["equipment_barcode"] = newBarcode;
    request.fields["equipment_category_id"] = newCategoryId;
    //create multipart using filepath, string or bytes
    var pic =
        await http.MultipartFile.fromPath("equipment_image", newImage.path);
    //add multipart to request
    request.files.add(pic);
    var response = await request.send();

    //Get the response from the server
    // var responseData = await response.stream.toBytes();
    // var responseString = String.fromCharCodes(responseData);
    return response;
  }

  Future<http.StreamedResponse> updateEquipment(
      String equipmentName,
      //XFile image,
      String categoryId,
      String condition,
      String size,
      String description,
      String barcode,
      String id) async {
    final String token = await SharedPrefrence().getToken();
    Map<String, String> headers = {
      "X-Api-Key": "632F2EC9771B6C4C0BDF30BE21D9009B",
      'x-token': token,
    };
    var request =
        http.MultipartRequest("POST", Uri.parse(super.updateEquipmentsPath));
    request.headers.addAll(headers);
    request.fields["equipment_name"] = equipmentName;
    request.fields["equipment_condition"] = condition;
    request.fields["equipment_size"] = size;
    request.fields["equipment_description"] = description;
    request.fields["equipment_barcode"] = barcode;
    request.fields["equipment_category_id"] = categoryId;
    request.fields["id"] = id;
    // var pic = await http.MultipartFile.fromPath("equipment_image", image.path);
    // request.files.add(pic);
    var response = await request.send();
    // ignore: unused_local_variable
    var responseData = await response.stream.toBytes();
    return response;
  }

  //
  Future<http.StreamedResponse> updateEventEquipment(
      String equipmentName,
      XFile image,
      String categoryId,
      String condition,
      String size,
      String description,
      String barcode,
      String id) async {
    final String token = await SharedPrefrence().getToken();
    Map<String, String> headers = {
      "X-Api-Key": "632F2EC9771B6C4C0BDF30BE21D9009B",
      'x-token': token,
    };
    var request =
        http.MultipartRequest("POST", Uri.parse(super.updateEquipmentsPath));
    request.headers.addAll(headers);
    request.fields["equipment_name"] = equipmentName;
    request.fields["equipment_condition"] = condition;
    request.fields["equipment_size"] = size;
    request.fields["equipment_description"] = description;
    request.fields["equipment_barcode"] = barcode;
    request.fields["equipment_category_id"] = categoryId;
    request.fields["id"] = id;
    var pic = await http.MultipartFile.fromPath("equipment_image", image.path);
    request.files.add(pic);
    var response = await request.send();
    // ignore: unused_local_variable
    var responseData = await response.stream.toBytes();
    return response;
  }

  Future<http.Response> deleteEquipment(String id) async {
    final String token = await SharedPrefrence().getToken();

    var body = jsonEncode({'id': id});
    final http.Response response =
        await http.post(Uri.parse(super.deleteEquipmentsPath + id),
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
      throw Exception('Failed to delete Equipment.');
    }
  }
}

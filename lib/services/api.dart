//list all api endpoints

class BaseAPI {
  static String apiKey = "632F2EC9771B6C4C0BDF30BE21D9009B";
  static String base = 'http://34.79.101.196';
  static var api = base + '/crisp_inventory/api';

  //http://34.79.101.196/crisp_inventory/api

  Map<String, String> headers = {
    "X-Api-Key": "632F2EC9771B6C4C0BDF30BE21D9009B",
    "Content-Type": "application/json"
  };

  // more routes
  var registerPath = api + "/user/signup";
  var loginPath = api + "/user/login";
  var logoutPath = api + "";
  var deleteUserPath = api + "/user/delete?id=";
  var profileUserPath = api + "/user/profile";
  var updateprofileUserPath = api + "/user/update_profile";
  var allUsersPath = api + "/user/all";

  var allEventsPath = api + "/events/all";
  var addEventsPath = api + "/events/add";
  var upDateEventsPath = api + "/Events/update";
  var deleteEventsPath = api + "/Events/delete?id=";
  var allFutureEventsPath = api + "/events_future/all";
  var allPastEventsPath = api + "/events_past/all";

  var allEquipmentsPath = api + "/equipments/all?limit=1000";
  var addEquipmentsPath = api + "/equipments/add";
  var updateEquipmentsPath = api + "/Equipments/update";
  var avialableEquipmentsPath = api + "/equipments_available/all?limit=1000";
  var notAvialableEquipmentsPath = api + "/equipments_not_available/all";

  var deleteEquipmentsPath = api + "/Equipments/delete?id=";
  var addEquipmentsCategoryPath = api + "/equipment_category/add";
  var deleteEquipmentsCategoryPath = api + "/Equipment_category/delete?id=";
  var allEquipmentsCategoryPath = api + "/equipment_category/all";
  var allEventEquipmentChecklistPath = api + "/event_equipment_checklist/all";
  var addEventEquipmentsChecklistPath = api + "/event_equipment_checklist/add";
  var updateEventEquipmentsChecklistPath =
      api + "/event_equipment_checklist/update";
  var detailEventEquipmentsChecklistPath =
      api + "/event_equipment_checklist/detail?id=";
  var deleteEventEquipmentsChecklistPath =
      api + "/event_equipment_checklist/delete";

  var allEquipmemntCheckInPath = api + "/equipment_checkin/all";
  var checkinEquipmentsPath = api + "/equipment_checkin/add";
  var deletecheckinEquipmentsPath = api + "/equipment_checkin/delete";
  var allEquipmemntCheckOutPath = api + "/event_equipment_checkout/all";
  var checkoutEquipmentsPath = api + "/event_equipment_checkout/add";
  var deleteEventsEquipmentChechoutPath =
      api + "/Event_equipment_checkout/delete";
}

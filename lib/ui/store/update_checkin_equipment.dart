import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viicsoft_inventory_app/component/button.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/popover.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/category.dart';
import 'package:viicsoft_inventory_app/models/equipments.dart';
import 'package:viicsoft_inventory_app/models/events.dart';
import 'package:viicsoft_inventory_app/services/provider/appdata.dart';
import 'package:viicsoft_inventory_app/services/provider/userdata.dart';

class UpdateCheckInEquipment extends StatefulWidget {
  final EquipmentElement equipment;
  final Event event;
  final int index;
  const UpdateCheckInEquipment(
      {Key? key,
      required this.equipment,
      required this.event,
      required this.index})
      : super(key: key);

  @override
  State<UpdateCheckInEquipment> createState() => _UpdateCheckInEquipmentState();
}

class _UpdateCheckInEquipmentState extends State<UpdateCheckInEquipment> {
  XFile? _itemimage;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  final picker = ImagePicker();

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(
        source: source, imageQuality: 50, maxHeight: 700, maxWidth: 650);

    setState(() {
      _itemimage = pickedFile;
    });
  }

  EquipmentCategory? newselectedCategory;
  TextEditingController? descriptionController;
  String? _newCondition;
  String _scanInBarcode = '';
  bool noImage = false;

  List data = [];

  @override
  void initState() {
    _newCondition = widget.equipment.equipmentCondition;
    descriptionController =
        TextEditingController(text: widget.equipment.equipmentDescription);
    super.initState();
  }

  Future scanInBarcode() async {
    String barcodescanIn;
    try {
      barcodescanIn = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodescanIn = 'Failed to get platform version.';
    }

    if (!mounted) return;
    setState(() {
      _scanInBarcode = barcodescanIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var provider = Provider.of<AppData>(context);
    var userData = Provider.of<UserData>(context).userData.fullName;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.white,
        toolbarHeight: screenSize.height * 0.11,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 25,
                color: AppColor.iconBlack,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              'Update ( ${widget.equipment.equipmentName} )',
              style: style.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
      body: Form(
        key: globalFormKey,
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: AppColor.homePageColor,
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20, left: 20),
                        child: ListView(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Image*',
                                  style: style.copyWith(
                                    color: AppColor.darkGrey,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                itemImages(context),
                                Text(
                                  noImage ? 'No image selected !' : '',
                                  style: style.copyWith(
                                      fontSize: 11, color: AppColor.red),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'New Condition*',
                              style: style.copyWith(
                                color: AppColor.darkGrey,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              height: 60,
                              width: screenSize.width,
                              decoration: BoxDecoration(
                                // color: AppColor.red,
                                border: Border.all(color: AppColor.buttonText),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30, right: 20),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    underline: const Divider(
                                        color: Colors.transparent),
                                    value: _newCondition,
                                    elevation: 0,
                                    style: style.copyWith(fontSize: 14),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _newCondition = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'NEW',
                                      'OLD',
                                      'BAD',
                                      'FAIR',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Comment*',
                              style: style.copyWith(
                                color: AppColor.darkGrey,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextFormField(
                              controller: descriptionController,
                              validator: (input) => (input!.isEmpty)
                                  ? "Enter Your Comment"
                                  : null,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(
                                    color: AppColor.textFormColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(
                                    color: AppColor.activetextFormColor,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 40.0, horizontal: 10.0),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                hintStyle:
                                    style.copyWith(color: AppColor.buttonText),
                                hintText: 'Description',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: MainButton(
                borderColor: Colors.transparent,
                child: Text(
                  'CHECK IN EQUIPMENT',
                  style: style.copyWith(
                    fontSize: 14,
                    color: AppColor.buttonText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: AppColor.primaryColor,
                onTap: () async {
                  if (globalFormKey.currentState!.validate()) {
                    if (_itemimage == null) {
                      setState(() {
                        noImage = true;
                      });
                    } else {
                      provider.updateCheckinEquipment(
                        context: context,
                        equipmentId: widget.equipment.id,
                        equipmentCondition: _newCondition!,
                        equipmentDescription: descriptionController!.text,
                        equipmentImage: _itemimage,
                      );
                      await _checkIn(
                        widget.equipment.equipmentBarcode,
                        widget.equipment.id,
                        provider,
                        widget.event.id,
                        userData!,
                      );
                      Navigator.pop(context);

                      setState(() {
                        noImage = false;
                      });
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column itemImages(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.25,
              height: MediaQuery.of(context).size.width * 0.22,
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.textFormColor),
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: _itemimage != null
                      ? FileImage(File(_itemimage!.path))
                      : const AssetImage('assets/white.jpg') as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: InkWell(
                onTap: () => showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Popover(
                      mainAxisSize: MainAxisSize.min,
                      child: Column(children: [
                        InkWell(
                          onTap: () {
                            getImage(ImageSource.camera);
                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.camera_alt_outlined),
                              const SizedBox(width: 10),
                              Text('Take a Pictue', style: style)
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            getImage(ImageSource.gallery);
                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.photo_library),
                              const SizedBox(width: 10),
                              Text('Select from gallery', style: style)
                            ],
                          ),
                        ),
                      ]),
                    );
                  },
                ),
                child: Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    color: AppColor.homePageTitle,
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 1.5,
                      color: Colors.white,
                    ),
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  //
  _checkIn(String? equipmentBarcode, String equipmentId, AppData provider,
      String eventId, String userData) async {
    await scanInBarcode();
    if (equipmentBarcode == _scanInBarcode) {
      return provider
          .addEventsEquipmentCheckIn(
        context: context,
        eventId: eventId,
        equipmentId: equipmentId,
        returnDatetime: DateTime.now(),
        checkinUserName: userData,
        equipmentImage: widget.equipment.equipmentImage,
        equipmentName: widget.equipment.equipmentName,
        eventName: widget.event.eventName,
        equipmentCondition: widget.equipment.equipmentCondition,
      )
          .then((value) async {
        await provider.checkedIn(equipmentId);
        provider.updateCheckOutEquipment(
          context: context,
          equipId: widget.equipment.id,
          checkinUser: userData,
        );
      });
    }
  }
}

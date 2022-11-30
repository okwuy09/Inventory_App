import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:viicsoft_inventory_app/component/button.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/mytextform.dart';
import 'package:viicsoft_inventory_app/component/popover.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/category.dart';
import 'package:viicsoft_inventory_app/services/provider/appdata.dart';

class AddEquipmentPage extends StatefulWidget {
  final EquipmentCategory? category;
  const AddEquipmentPage({Key? key, this.category}) : super(key: key);

  @override
  State<AddEquipmentPage> createState() => _AddEquipmentPageState();
}

class _AddEquipmentPageState extends State<AddEquipmentPage> {
  XFile? _itemimage;
  String _newCondition = 'NEW';
  String _newSize = 'SHORT';
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  TextEditingController descriptionController = TextEditingController();
  final TextEditingController _equipmentNameController =
      TextEditingController();
  final picker = ImagePicker();
  bool noImage = false;

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(
        source: source, imageQuality: 50, maxHeight: 700, maxWidth: 650);

    setState(() {
      _itemimage = pickedFile;
    });
  }

  String _scanBarcode = '';
  EquipmentCategory? newselectedCategory;

  Future scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  List data = [];

  @override
  void dispose() {
    descriptionController.dispose();
    _equipmentNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var provider = Provider.of<AppData>(context);
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
            const SizedBox(width: 10),
            Text(
              'Add New Equipment ( ${widget.category!.name} )',
              style: style.copyWith(
                fontSize: 16,
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
                            const SizedBox(height: 10),
                            Text(
                              'Equipment name*',
                              style: style.copyWith(
                                color: AppColor.darkGrey,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            MyTextForm(
                              controller: _equipmentNameController,
                              obscureText: false,
                              labelText: 'Enter equipment name',
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Equipment condition*',
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
                            const SizedBox(height: 5),
                            Text(
                              'Equipment size*',
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
                                    underline: const Divider(
                                        color: Colors.transparent),
                                    isExpanded: true,
                                    value: _newSize,
                                    elevation: 16,
                                    style: style.copyWith(fontSize: 14),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _newSize = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'SHORT',
                                      'LONG',
                                      'VERY LONG',
                                      'VERY SHORT',
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
                            const SizedBox(height: 5),
                            Text(
                              'Equipment description*',
                              style: style.copyWith(
                                color: AppColor.darkGrey,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextFormField(
                              controller: descriptionController,
                              validator: (input) => (input!.isEmpty)
                                  ? "Add Equipment Description"
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
                                    vertical: 25.0, horizontal: 10.0),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                hintStyle:
                                    style.copyWith(color: AppColor.buttonText),
                                hintText: 'Description',
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Scan equipment*',
                              style: style.copyWith(
                                color: AppColor.darkGrey,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                    elevation:
                                        MaterialStateProperty.all<double>(0),
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                            const EdgeInsets.all(15)),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                      AppColor.buttonText,
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  onPressed: () => scanBarcodeNormal(),
                                  child: const Text('Scan Barcode'),
                                ),
                                Expanded(child: Container()),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColor.textFormColor),
                                      borderRadius: BorderRadius.circular(12)),
                                  height: 50,
                                  width: screenSize.height * 0.25,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, right: 6, left: 6, bottom: 3),
                                    child: Text('$_scanBarcode\n',
                                        style: const TextStyle(fontSize: 14)),
                                  ),
                                ),
                              ],
                            ),

                            //
                            const SizedBox(height: 5),
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
                child: provider.isAddingEquipment
                    ? buttonCircularIndicator
                    : Text(
                        'ADD NEW EQUIPMENT',
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
                      setState(() {
                        noImage = false;
                      });
                    }
                    await provider.addNewEquipment(
                      context: context,
                      equipmentName: _equipmentNameController.text,
                      equipmentCondition: _newCondition,
                      equipmentSize: _newSize,
                      equipmentDescription: descriptionController.text,
                      equipmentBarcode: _scanBarcode,
                      equipmentCategoryId: widget.category!.id,
                      equipmentImage: _itemimage,
                    );
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
}

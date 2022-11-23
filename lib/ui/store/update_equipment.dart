import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/button.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/mytextform.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/models/category.dart';
import 'package:viicsoft_inventory_app/models/equipments.dart';
import 'package:viicsoft_inventory_app/services/apis/equipment_api.dart';

class UpdateEquipmentPage extends StatefulWidget {
  final EquipmentElement? equipment;
  const UpdateEquipmentPage({Key? key, this.equipment}) : super(key: key);

  @override
  State<UpdateEquipmentPage> createState() => _UpdateEquipmentPageState();
}

class _UpdateEquipmentPageState extends State<UpdateEquipmentPage> {
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
  final EquipmentAPI _equipmentApi = EquipmentAPI();
  String? _newCondition;

  List data = [];

  @override
  void initState() {
    _newCondition = widget.equipment!.equipmentCondition;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    String _newSize = widget.equipment!.equipmentSize;
    TextEditingController descriptionController =
        TextEditingController(text: widget.equipment!.equipmentDescription);
    TextEditingController _equipmentNameController =
        TextEditingController(text: widget.equipment!.equipmentName);
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
              'Edit Equipment ( ${widget.equipment!.equipmentName} )',
              style: style.copyWith(
                fontSize: 15,
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
                            const SizedBox(height: 20),
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
                child: Text(
                  'UPDATE EQUIPMENT',
                  style: style.copyWith(
                    fontSize: 14,
                    color: AppColor.buttonText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: AppColor.primaryColor,
                onTap: () async {
                  if (globalFormKey.currentState!.validate()) {
                    var res = await _equipmentApi.updateEquipment(
                      _equipmentNameController.text,
                      widget.equipment!.equipmentCategoryId,
                      _newCondition!,
                      _newSize,
                      descriptionController.text,
                      widget.equipment!.equipmentBarcode!,
                      widget.equipment!.id,
                    );
                    if (res.statusCode == 200 || res.statusCode == 201) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(
                              "${_equipmentNameController.text} Updated successfully")));
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Something went wrong"),
                        ),
                      );
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
                      : NetworkImage(widget.equipment!.equipmentImage)
                          as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

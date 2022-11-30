import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:viicsoft_inventory_app/component/button.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/mytextform.dart';
import 'package:viicsoft_inventory_app/component/popover.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/services/provider/appdata.dart';

class CategorySheet extends StatefulWidget {
  const CategorySheet({Key? key}) : super(key: key);

  @override
  State<CategorySheet> createState() => _CategorySheetState();
}

class _CategorySheetState extends State<CategorySheet> {
  final TextEditingController _categoryName = TextEditingController();
  final GlobalKey<FormState> _globalFormKey = GlobalKey<FormState>();

  XFile? _categoryimage;
  final picker = ImagePicker();
  bool noImage = false;

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(
        source: source, imageQuality: 50, maxHeight: 700, maxWidth: 650);

    setState(() {
      _categoryimage = pickedFile;
    });
  }

  @override
  void dispose() {
    _categoryName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppData>(context);
    return Form(
      key: _globalFormKey,
      child: Padding(
        padding: EdgeInsets.only(
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Popover(
          mainAxisSize: MainAxisSize.min,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New equipment category',
                style: style.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              categoryImages(context),
              Center(
                child: Text(
                  noImage ? 'No image selected !' : '',
                  style: style.copyWith(fontSize: 12, color: AppColor.red),
                ),
              ),
              const SizedBox(height: 10),
              MyTextForm(
                controller: _categoryName,
                obscureText: false,
                labelText: 'Enter new equipmet category name',
                validatior: (input) =>
                    input!.isEmpty ? "Enter category name*" : null,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: MainButton(
                  borderColor: Colors.transparent,
                  backgroundColor: AppColor.primaryColor,
                  child: provider.isCreatingCategory
                      ? buttonCircularIndicator
                      : Text(
                          'DONE',
                          style: style.copyWith(
                            fontSize: 14,
                            color: AppColor.buttonText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  onTap: () async {
                    if (_globalFormKey.currentState!.validate()) {
                      if (_categoryimage == null) {
                        setState(() {
                          noImage = true;
                        });
                      } else {
                        setState(() {
                          noImage = false;
                        });
                      }
                      await provider.createEquipmentCategory(
                        context: context,
                        categoryName: _categoryName.text,
                        categoryImage: _categoryimage,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column categoryImages(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.darkGrey),
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: _categoryimage != null
                      ? FileImage(File(_categoryimage!.path))
                      : const AssetImage('assets/No_image.png')
                          as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: -1,
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
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
                  );
                },
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: AppColor.homePageTitle,
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 1.5,
                      color: Colors.white,
                    ),
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 10,
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

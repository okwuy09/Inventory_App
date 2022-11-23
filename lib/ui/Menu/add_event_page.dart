import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:viicsoft_inventory_app/component/button.dart';
import 'package:viicsoft_inventory_app/component/colors.dart';
import 'package:viicsoft_inventory_app/component/datefield.dart';
import 'package:viicsoft_inventory_app/component/mytextform.dart';
import 'package:viicsoft_inventory_app/component/popover.dart';
import 'package:viicsoft_inventory_app/component/style.dart';
import 'package:viicsoft_inventory_app/component/success_button_sheet.dart';
import 'package:viicsoft_inventory_app/services/apis/event_api.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({Key? key}) : super(key: key);

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  XFile? _eventImage;
  DateTime? selecteddate;
  bool hasData = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final TextEditingController _eventName = TextEditingController();
  final TextEditingController _eventType = TextEditingController();
  final TextEditingController _eventLocation = TextEditingController();
  DateTime startingDate = DateTime.now();
  DateTime endingDate = DateTime.now();
  final EventAPI _eventAPI = EventAPI();
  bool noImage = false;

  final picker = ImagePicker();

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(
        source: source, imageQuality: 50, maxHeight: 700, maxWidth: 650);

    setState(() {
      _eventImage = pickedFile;
    });
  }

  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  void dispose() {
    _eventName.dispose();
    _eventLocation.dispose();
    _eventType.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.homePageColor,
      body: Form(
        key: globalFormKey,
        child: Column(
          children: [
            Container(
              color: AppColor.white,
              padding: const EdgeInsets.only(top: 50, left: 10, right: 30),
              width: screenSize.width,
              height: 110,
              child: Column(
                children: [
                  Row(
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
                      const SizedBox(width: 16.5),
                      Text(
                        'Create Event',
                        style: style.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 22, right: 22),
                width: screenSize.width,
                child: Column(
                  children: [
                    Expanded(
                      child: MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: ListView(
                          children: [
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                eventImages(context),
                                const SizedBox(height: 5),
                                Text(
                                  'Choose event image*',
                                  style: style.copyWith(
                                    fontSize: 11,
                                    color: AppColor.darkGrey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Center(
                              child: Text(
                                noImage ? 'No image selected !' : '',
                                style: style.copyWith(
                                  fontSize: 11,
                                  color: AppColor.red,
                                ),
                              ),
                            ),

                            Text(
                              'Event name*',
                              style: style.copyWith(
                                color: AppColor.darkGrey,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            // event location
                            MyTextForm(
                              controller: _eventName,
                              obscureText: false,
                              validatior: (input) =>
                                  (input!.isEmpty) ? "Enter Event Name" : null,
                              labelText: 'Enter event name',
                            ),
                            SizedBox(height: screenSize.width * 0.015),
                            //
                            Text(
                              'Event type*',
                              style: style.copyWith(
                                color: AppColor.darkGrey,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            // event type
                            MyTextForm(
                              controller: _eventType,
                              obscureText: false,
                              validatior: (input) =>
                                  (input!.isEmpty) ? "Enter Event Type" : null,
                              labelText: 'Enter event type',
                            ),
                            SizedBox(height: screenSize.width * 0.015),
                            //
                            Text(
                              'Event location*',
                              style: style.copyWith(
                                fontSize: 11,
                                color: AppColor.darkGrey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            // event location
                            MyTextForm(
                              controller: _eventLocation,
                              obscureText: false,
                              validatior: (input) => (input!.isEmpty)
                                  ? "Enter Event Location"
                                  : null,
                              labelText: 'Enter event location',
                            ),
                            SizedBox(height: screenSize.width * 0.015),

                            Text(
                              'Event starting Date',
                              style: style.copyWith(
                                fontSize: 11,
                                color: AppColor.darkGrey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            // starting date
                            DateField(
                              pickedDate:
                                  '${startingDate.day} ${months[startingDate.month - 1]}, ${startingDate.year}',
                              onPressed: () => _startingDate(context),
                            ),

                            SizedBox(height: screenSize.width * 0.015),
                            Text(
                              'Event ending Date',
                              style: style.copyWith(
                                fontSize: 11,
                                color: AppColor.darkGrey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            // ending date
                            DateField(
                              pickedDate:
                                  '${endingDate.day}  ${months[endingDate.month - 1]}, ${endingDate.year}',
                              onPressed: () => _endingDate(context),
                            ),

                            //
                            SizedBox(height: screenSize.width * 0.1),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                MainButton(
                                  borderColor: Colors.transparent,
                                  child: Text(
                                    'CREATE EVENT',
                                    style: style.copyWith(
                                      fontSize: 14,
                                      color: AppColor.buttonText,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  backgroundColor: AppColor.primaryColor,
                                  onTap: () async {
                                    if (globalFormKey.currentState!
                                        .validate()) {
                                      if (_eventImage == null) {
                                        setState(() {
                                          noImage = true;
                                        });
                                      } else {
                                        setState(() {
                                          noImage = false;
                                        });
                                      }
                                      var res = await _eventAPI.addEvent(
                                          _eventName.text,
                                          _eventImage!,
                                          _eventType.text,
                                          _eventLocation.text,
                                          endingDate.toString(),
                                          startingDate.toString());

                                      if (res.statusCode == 200) {
                                        successButtomSheet(
                                            context: context,
                                            buttonText: 'CONTINUE',
                                            title:
                                                ' Event Created \n  Successfully!',
                                            onTap: () =>
                                                Navigator.pop(context));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            backgroundColor: Colors.red,
                                            content:
                                                Text("Something went wrong"),
                                          ),
                                        );
                                      }
                                    }
                                  },
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
          ],
        ),
      ),
    );
  }

  Column eventImages(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.16,
              height: MediaQuery.of(context).size.width * 0.14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.02),
                image: DecorationImage(
                  image: _eventImage != null
                      ? FileImage(File(_eventImage!.path))
                      : const AssetImage('assets/white.jpg') as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: -1,
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
                  height: 18,
                  width: 18,
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

  _startingDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      confirmText: 'SET DATE',
      initialDate: startingDate,
      firstDate: DateTime(2016),
      lastDate: DateTime(2030),
    );
    if (selected != null && selected != startingDate) {
      setState(() {
        startingDate = selected;
        endingDate = selected;
      });
    }
  }

  _endingDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: endingDate,
      firstDate: DateTime(2016),
      lastDate: DateTime(2030),
    );
    if (selected != null && selected != endingDate) {
      setState(() {
        endingDate = selected;
      });
    }
  }
}
